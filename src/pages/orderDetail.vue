<template>
  <div class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-3xl mx-auto">
      <h1 class="text-3xl font-bold mb-8 text-center">订单详情</h1>
      <div class="space-y-6">
        <!-- 收货地址卡片 -->
        <Card class="bg-white dark:bg-slate-900 shadow-lg">
          <CardHeader>
            <CardTitle class="flex items-center text-xl text-gray-800 dark:text-gray-200">
              <MapPin class="mr-2 h-5 w-5 text-green-500" />
              收货地址
            </CardTitle>
          </CardHeader>
          <CardContent class="space-y-2">
            <div v-if="isloading" class="space-y-2">
              <Skeleton class="h-6 w-3/4" />
              <Skeleton class="h-6 w-full" />
              <Skeleton class="h-6 w-2/3" />
            </div>
            <template v-else>
              <p class="flex items-center">
                <User class="mr-2 h-4 w-4 text-gray-500" />
                <span class="font-medium">联系人：</span>
                <span class="ml-2 text-orange-500">{{ product.consignee }}</span>
              </p>
              <p class="flex items-center">
                <MapPin class="mr-2 h-4 w-4 text-gray-500" />
                <span class="font-medium">收货地址：</span>
                <span class="ml-2 text-orange-500">{{ product.address }}</span>
              </p>
              <p class="flex items-center">
                <Phone class="mr-2 h-4 w-4 text-gray-500" />
                <span class="font-medium">手机号：</span>
                <span class="ml-2 text-orange-500">{{ product.phone }}</span>
              </p>
            </template>
          </CardContent>
        </Card>

        <!-- 订单信息卡片 -->
        <Card class="bg-white dark:bg-slate-900 shadow-lg">
          <CardHeader>
            <CardTitle class="flex items-center text-xl text-gray-800 dark:text-gray-200">
              <Package class="mr-2 h-5 w-5 text-blue-500" />
              订单信息
            </CardTitle>
          </CardHeader>
          <CardContent class="space-y-4">
            <div v-if="isloading" class="space-y-4">
              <Skeleton class="h-6 w-1/2" />
              <Skeleton class="h-6 w-2/3" />
              <Skeleton class="h-6 w-3/4" />
              <div class="flex items-center space-x-4">
                <Skeleton class="w-24 h-24 rounded-md" />
                <div class="space-y-2 flex-1">
                  <Skeleton class="h-6 w-3/4" />
                  <Skeleton class="h-6 w-1/2" />
                </div>
              </div>
            </div>
            <template v-else>
              <p class="flex items-center cursor-pointer" @click="goToUserDetail">
                <User class="mr-2 h-4 w-4 text-gray-500" />
                <span v-if="buyOrSell" class="font-medium">{{ buyOrSell === "1" ? '卖家' : '买家' }}：</span>
                <span v-else class="font-medium">卖家：</span>
                <span @click="product.userId ? router.push({path:'/userDetail',query:{id:product.userId}}) : ''" class="ml-2 text-blue-500 hover:underline">{{ product.username ? product.username : '小碳官方' }}</span>
              </p>
              <p class="flex items-center">
                <Truck class="mr-2 h-4 w-4 text-gray-500" />  
                <span class="font-medium">订单进度：</span>
                <Badge :class="statusColor" class="ml-2">
                  {{ product.status }}
                </Badge>
              </p>
              <p v-if="product.statusMessage !== '待发货' && product.statusMessage !== '已取消'" class="flex items-center cursor-pointer">
                <Package class="mr-2 h-4 w-4 text-gray-500" />
                <span class="font-medium">快递单号：</span>
                <span class="ml-2 text-blue-500 hover:underline">{{ product.trackingNumber === null ? '暂未发货' : product.trackingNumber }}</span>
              </p>
              <div @click="detail(product.productId)" class="flex items-center space-x-4 cursor-pointer bg-gray-50 dark:bg-slate-800 p-4 rounded-lg transition duration-300 ease-in-out hover:bg-gray-100 dark:hover:bg-slate-700">
                <img :src="product.image" :alt="product.title" class="w-24 h-24 object-cover rounded-md shadow-sm" />
                <div>
                  <h3 class="font-medium text-gray-800 dark:text-gray-200">{{ product.title }}</h3>
                  <p class="text-lg font-semibold text-green-600 dark:text-green-400 mt-2">
                    ¥{{ product.amount }}
                  </p>
                </div>
              </div>
            </template>
          </CardContent>
          <CardFooter class="bg-gray-50 dark:bg-slate-800 rounded-b-lg">
            <div class="w-full">
              <label for="remark" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">备注</label>
              <div v-if="isloading">
                <Skeleton class="h-10 w-full" />
              </div>
              <Input
                v-else
                id="remark"
                v-model="product.remark"
                placeholder="无"
                disabled
                class="w-full bg-white dark:bg-slate-700 text-gray-800 dark:text-gray-200 border-gray-300 dark:border-gray-600"
              />
            </div>
          </CardFooter>
        </Card>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Badge } from "@/components/ui/badge"
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
import { Skeleton } from '@/components/ui/skeleton'

import { ref, onMounted, watch,computed } from 'vue'
import api from '@/utils/api'
import { useRoute, useRouter } from 'vue-router'
import { useUser } from '@/utils/pinia'
import { success, info, warning } from '@/utils/message'
import { Loader2,Package ,Truck  } from 'lucide-vue-next'

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
const buyOrSell = ref()
const user = useUser()
const orderId = ref(null)
const product = ref({
    categoryId: Number,
    price: Number,
    title: String,
    desc: String,
    freight: Number,
    image: Array,
    createTime: String,//创建时间--发布时间
    collectionNum: Number,//收藏量
    username: String,//用户名
    avatar: String,//用户头像
    rate: Number,//卖家评分
    collectionStatus: Number,
    userId: Number
})

const statusColor = computed(() => {
  const colors = {
    '待付款': 'bg-yellow-500',
    '待发货': 'bg-blue-500',
    '已发货': 'bg-green-500',
    '已完成': 'bg-purple-500',
    '已取消': 'bg-red-500'
  }
  return colors[product.value.statusMessage] || 'bg-gray-500'
})

onMounted(() => {
    ////console.log(route.query)
    if (route.query.id === null || route.query.buyOrSell === null) {
        router.push({ path: '/404' })
    } else {
        id.value = Number(route.query.id)
        buyOrSell.value = route.query.buyOrSell
        loadProduct()
    }
})

const loadProduct = async () => {
    isloading.value = true
    if (id.value === -1)
        router.push({ path: '/' })
    await api({
        url: '/user/order/detail',
        method: 'POST',
        data: {
            buyOrSell: buyOrSell.value,
            id: id.value
        }
    }).then(res => {
        product.value = { ...res.data }
        ////console.log(product.value)
    }).finally(() => { isloading.value = false })
}


watch(() => openDialog.value, (newValue, oldValue) => {
    if (newValue === false) {
        info('支付已取消,订单将保留15分钟')
        router.push('/orderCenter')
    }
})

const detail = async (id) => {
    router.push({
        path: '/detail',
        query: {
            productId: id
        }
    })
}

</script>