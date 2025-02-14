<template>
    <div class="bg-slate-100 dark:bg-slate-900 min-h-[90vh]">
        <div class="container mx-auto p-4 max-w-4xl dark:*:text-white">
            <h1 class="text-2xl font-bold mb-6 text-gray-800">确认订单</h1>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="md:col-span-2 space-y-6">
                    <Card>
                        <CardHeader class="flex flex-row items-center justify-between">
                            <CardTitle class="text-lg font-semibold text-gray-700 dark:text-slate-100">收货地址</CardTitle>
                            <addressAdd @update="getAddressList">
                                <Button>添加地址</Button>
                            </addressAdd>
                        </CardHeader>
                        <CardContent>
                            <selectItem v-model="address" :holder="'选择收货地址'">
                                <template #item>
                                    <SelectItem v-for="address in addresses" :key="address.id"
                                        :value="String(address.id)">
                                        <div class="flex items-start">
                                            <MapPin class="mr-2 h-4 w-4 mt-1 flex-shrink-0 text-gray-500" />
                                            <div>
                                                <div class="font-medium">{{ address.address }}</div>
                                                <div class="text-sm text-gray-500">
                                                    <span class="mr-2">
                                                        <User class="inline-block mr-1 h-3 w-3" />
                                                        {{ address.consignee }}
                                                    </span>
                                                    <span>
                                                        <Phone class="inline-block mr-1 h-3 w-3" />
                                                        {{ address.phone }}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </SelectItem>
                                </template>
                            </selectItem>
                        </CardContent>
                    </Card>

                    <Card>
                        <CardHeader>
                            <CardTitle class="text-lg font-semibold text-gray-700 dark:text-slate-100">订单信息</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <h1 class="text-md font-semibold mb-2">卖家：<span class="text-orange-500">小碳二手交易平台</span></h1>
                            <div class="flex items-center space-x-4">
                                <img :src="product.images[0]" :alt="product.title"
                                    class="w-24 h-24 object-cover rounded-md shadow-sm" />
                                <div>
                                    <h3 class="font-medium text-gray-800 dark:text-slate-100">{{ product.title }}</h3>
                                    <p class="text-sm text-gray-500 mt-1">
                                        价格: ¥{{ product.pointsPrice }}
                                    </p>
                                </div>
                            </div>
                        </CardContent>
                        <CardFooter>
                            <Input v-model="orderNote" placeholder="订单备注（选填）" class="w-full text-black" />
                        </CardFooter>
                    </Card>
                </div>

                <div>
                    <Card>
                        <CardHeader>
                            <CardTitle class="text-lg font-semibold text-gray-700 dark:text-slate-100">兑换详情</CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div class="space-y-2">
                                <div class="flex justify-between text-sm">
                                    <span class="text-gray-600 dark:text-slate-50">积分</span>
                                    <span class="font-medium">¥{{ product.pointsPrice }}</span>
                                </div>
                                <div class="flex justify-between text-sm">
                                    <span class="text-gray-600 dark:text-slate-100">运费</span>
                                    <span class="font-medium">¥0</span>
                                </div>
                                <Separator class="my-2" />
                                <div class="flex justify-between text-base font-bold">
                                    <span>所需积分</span>
                                    <span class="text-red-500">¥{{ (product.pointsPrice) }}</span>
                                </div>
                            </div>
                        </CardContent>
                        <CardFooter>
                            <Button class="w-full bg-orange-500 hover:bg-orange-600 text-white"
                                @click="orderSubmit">
                                <span v-if="!isloading">兑换</span>
                                <span v-else class="flex items-center">
                                    <Loader2 class="w-4 h-4 mr-2 animate-spin" />
                                    等待服务器处理中...
                                </span>
                            </Button>
                        </CardFooter>
                    </Card>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
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
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { MapPin, Phone, User, X } from 'lucide-vue-next'
import selectItem from '@/components/selectItem.vue'
import addressAdd from '../components/addressAdd.vue'

import { ref, onMounted, watch } from 'vue'
import api from '@/utils/api'
import { useRoute, useRouter } from 'vue-router'
import { useUser } from '@/utils/pinia'
import { success, info, warning } from '@/utils/message'
import { Loader2 } from 'lucide-vue-next'

//页面加载
const isloading = ref(false)
//路由管理
const openDialog = ref(false)
const route = useRoute()
const router = useRouter()
// 页面数据
const address = ref('')
const orderNote = ref(null)
const addresses = ref([])
const id = ref()
const user = useUser()
const orderId = ref(null)
const product = ref({
    categoryId: Number,
    price: Number,
    title: String,
    desc: String,
    freight: Number,
    images: Array,
    createTime: String,//创建时间--发布时间
    collectionNum: Number,//收藏量
    username: String,//用户名
    avatar: String,//用户头像
    rate: Number,//卖家评分
    collectionStatus: Number,
    userId: Number
})

const emits = defineEmits(['close'])

onMounted(() => {
    if (!route.query.id) {
        // router.push({ path: '/' })
    } else {
        id.value = Number(route.query.id)
        loadProduct()
    }
    getAddressList()
})

const getAddressList = async () => {
    await api({
        url: '/user/addressBook/getAll',
        method: 'GET',
    }).then(res => {
        addresses.value = res.data
    })
}

const loadProduct = async () => {
    if (id.value === -1)
        router.push({ path: '/' })
    await api({
        url: '/user/pointsProduct/detail',
        method: 'GET',
        params: {
            id: id.value,
        }
    }).then(res => {
        product.value = { ...res.data }
        //console.log(product.value)
    })
}

const orderSubmit = async () => {
    if (address.value === '') {
        info("请选择地址")
        return
    }
    isloading.value = true
    await api({
        method: 'POST',
        url: "/user/order/addPoints",
        data: {
            addressBookId: Number(address.value),
            pointsProductId: id.value,
            remark: orderNote.value
        }
    }).then(res => {
        if (res.code === 1) {
            orderId.value = res.data
            openDialog.value = true
            router.push({
                path:'/success',
                query:{
                    msg:"兑换成功"
                }
            })
        }
    }).finally(() => {
        isloading.value = false
    })
}

watch(() => openDialog.value, (newValue, oldValue) => {
    if (newValue === false) {
        info('支付已取消,订单将保留15分钟')
        router.push('/orderCenter')
    }
})
</script>