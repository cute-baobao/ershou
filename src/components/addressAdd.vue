<template>
    <Dialog :open="openDialog">
        <DialogTrigger :open="false" as-child @click="openDialog = true">
            <slot>
                <el-button @click="getAddressById" size="small" type="primary">
                    编辑
                </el-button>
            </slot>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>添加地址</DialogTitle>
                <DialogDescription>
                    管理收货地址
                </DialogDescription>
            </DialogHeader>
            <div class="space-y-2">
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right">
                            收货人
                        </Label>
                        <Input v-model="consignee" id="name" class="col-span-3" required />
                    </div>
                </div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right">
                            手机号码
                        </Label>
                        <Input minlength="13" maxlength="13"v-model="phone" id="name" class="col-span-3" required />
                    </div>
                </div>
                <div class="grid gap-4 grid-cols-4 items-center py-2">
                    <Label class="text-right">省/市/区</Label>
                    <selectItem v-model="privince" :holder="'选择省份'">
                        <template #item>
                            <SelectGroup>
                                <SelectLabel>省份</SelectLabel>
                                <SelectItem v-for="(item,index) in address" :key="index" :value="String(index)">
                                    {{item.name}}
                                </SelectItem>
                            </SelectGroup>
                        </template>
                    </selectItem>
                    <selectItem v-model="city" :holder="'选择城市'">
                        <template #item>
                            <SelectGroup>
                                <SelectLabel>城市</SelectLabel>
                                <SelectItem v-for="(item,index) in address[Number(privince)].city" :key="index" :value="String(index)">
                                    {{item.name}}
                                </SelectItem>
                            </SelectGroup>
                        </template>
                    </selectItem>
                    <selectItem v-model="area" :holder="'选择区县'">
                        <template #item>
                             <SelectGroup>
                                <SelectLabel>区县</SelectLabel>
                                <SelectItem v-for="(item,index) in address[Number(privince)].city[Number(city)].districtAndCounty" :key="index" :value="String(index)">
                                    {{item}}
                                </SelectItem>
                            </SelectGroup>
                        </template>
                    </selectItem>
                </div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right">
                            详细地址
                        </Label>
                        <Input v-model="address1" id="name" class="col-span-3" required />
                    </div>
                </div>
            </div>
            <template #close>
                <DialogClose
                    class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground" @click="openDialog = false"
                >
                    <X class="w-4 h-4" />
                    <span class="sr-only">Close</span>
                </DialogClose>
            </template>
            <DialogFooter>
                <Button variant="outline" @click="openDialog = false">
                    <span>取消</span>
                </Button>
                <Button @click="props.id===null?addAddress():updateAddress()">
                    <span v-if="!upload">
                        {{ props.id===null?'确认':'修改' }}
                    </span>
                    <span class="flex items-center" v-else>
                        <Loader2 class="mr-2 h-4 w-4 animate-spin" />上传中...
                    </span>
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
</template>

<script setup>
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogClose,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from '@/components/ui/dialog'
import {
    SelectGroup,
    SelectItem,
    SelectLabel,
} from '@/components/ui/select'
import selectItem from './selectItem.vue';
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label';

import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { Loader2,X } from 'lucide-vue-next'
import { address } from '@/utils/address'

const props = defineProps({
    id:{type:Number,default:null}
})
// 定义事件
const emits = defineEmits(['update'])
//控制dialog显示
const openDialog = ref(false)
//页面数据
const privince = ref("0")
const city = ref("0")
const area = ref("0")
//提交添加或修改表单的数据
const consignee = ref('')
const phone = ref('')
const address1 = ref('')
const upload = ref(false)

watch(() => privince.value, (newValue, oldValue) => {
    city.value = "0"
    area.value = "0"
})

const addAddress = async ()=> {
    if(consignee.value===''||phone.value===''||address1.value==='') {
        info("请填写完整信息")
        return 
    }
    var privince1 = address[Number(privince.value)].name
    var city1 = address[Number(privince.value)].city[Number(city.value)].name
    var area1 = address[Number(privince.value)].city[Number(city.value)].districtAndCounty[Number(area.value)]
    if(privince1===undefined)
        return info("请选择省份")
    else if(city1===undefined)
        return info("请选择城市")
    else if(area1===undefined)
        area1 = ''
    upload.value = true
    await api({
        url:'/user/addressBook/add',
        method:"POST",
        data:{
            consignee:consignee.value,
            phone:phone.value,
            address:privince1+city1+area1+address1.value,
            isDefault:0
        }
    }).then(res=>{
        if(res.code===1) {
            emits('update')
            success("添加成功")
            openDialog.value = false
        }
    }).finally(()=>{
        upload.value = false
    })
}

const updateAddress = async ()=> {
    if(consignee.value===''||phone.value===''||address1.value==='') {
        info("请填写完整信息")
        return 
    }
    var privince1 = address[Number(privince.value)].name
    var city1 = address[Number(privince.value)].city[Number(city.value)].name
    var area1 = address[Number(privince.value)].city[Number(city.value)].districtAndCounty[Number(area.value)]
    if(privince1===undefined)
        return info("请选择省份")
    else if(city1===undefined)
        return info("请选择城市")
    else if(area1===undefined)
        area1 = ''
    upload.value = true
    await api({
        url:'/user/addressBook/update',
        method:"PUT",
        data:{
            id:props.id,
            consignee:consignee.value,
            phone:phone.value,
            address:privince1+city1+area1+address1.value,
        }
    }).then(res=>{
        if(res.code===1) {
            emits('update')
            success("修改成功")
            openDialog.value = false
        }
    }).finally(()=>{
        upload.value = false
    })
}

const getAddressById = async ()=> {
    if(props.id===null) return
    await api({
        url:`/user/addressBook/get/${props.id}`
    }).then(res=>{
        if(res.code===1) {
            consignee.value = res.data.consignee
            phone.value = res.data.phone
        }
    })
}

const openHandler = ()=> {
    openDialog.value = true
    getAddressById()
}

</script>
