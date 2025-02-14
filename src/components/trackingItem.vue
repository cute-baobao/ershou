<template>
    <Dialog :open="openDialog">
        <DialogTrigger :open="false" @click="openDialog = true">
            <Button class="bg-gray-50" variant="outline">发货</Button>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>发货</DialogTitle>
                <DialogDescription>
                    填写快递单号，完成发货
                </DialogDescription>
            </DialogHeader>
            <div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right font-semibold text-xl">
                            快递单号：
                        </Label>
                        <Input @keyup.enter="submit" v-model="trackingNumber" maxlength="20" id="name" class="col-span-3" />
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
                <Button @click="submit">
                    <span v-if="!request">提交</span>
                        <span v-else class="flex items-center">
                            <Loader2 class="w-4 h-4 mr-2 animate-spin"/>
                            loading
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
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
    DialogClose
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label';

import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { useRouter } from 'vue-router';
import { X, Loader2 } from "lucide-vue-next"
import Input from './ui/input/Input.vue';

const props = defineProps({
    orderId: Number,
})
const emits = defineEmits(['update'])
// 引入路由
const openDialog = ref(false)
const router = useRouter()
// 页面数据
const request = ref(false)
const trackingNumber = ref("")

const submit = () => {
    if(trackingNumber.value==="")
        return warning('请输入快递单号')
    request.value = true
    api({
        url:'/user/order/deliver',
        method:"PUT",
        data:{
            id:props.orderId,
            trackingNumber:trackingNumber.value
        }
    }).then(res => {
        if(res.code === 1) {
            success('发货成功')
            emits('update')
            openDialog.value = false
        }
    }).finally(() => {
        request.value = false
    })
}
</script>
