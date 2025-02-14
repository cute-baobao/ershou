<template>
  <div class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100">
    <div class="container px-4 sm:px-6 lg:px-8 py-6 mx-auto max-w-7xl">
      <h1 class="text-2xl font-bold text-center text-green-600 dark:text-green-400 mb-6">积分商品订单</h1>

      <!-- Order Status Tabs -->
      <Tabs defaultValue="0" class="w-full mb-6">
        <TabsList class="grid w-full grid-cols-4 lg:grid-cols-5 bg-main/30 dark:bg-slate-800 rounded-lg shadow-md">
          <TabsTrigger @click="change(item.value)" v-for="item in status" :key="item.value" :value="item.value">
            {{ item.name }}
          </TabsTrigger>
        </TabsList>
      </Tabs>

      <!-- skeleton loading -->
      <div v-if="dataIsLoading" class="space-y-3">
        <div v-for="i in 6" :key="i" class="bg-white dark:bg-slate-800 rounded-lg overflow-hidden shadow-md">
          <!-- Skeleton Order Header -->
          <div class="bg-gray-50 dark:bg-slate-700 px-4 py-2 flex justify-between items-center">
            <div class="flex items-center space-x-2">
              <Skeleton class="h-6 w-6 rounded-full" />
              <Skeleton class="h-4 w-24" />
            </div>
            <Skeleton class="h-4 w-32" />
          </div>

          <!-- Skeleton Order Content -->
          <div class="p-3 flex items-center space-x-3">
            <Skeleton class="h-16 w-16 rounded-md" />
            <div class="flex-grow">
              <Skeleton class="h-4 w-3/4 mb-1" />
              <Skeleton class="h-4 w-1/2" />
            </div>
            <Skeleton class="h-8 w-20 rounded-md" />
          </div>
        </div>
      </div>

      <!-- Order List -->
      <div v-if="orderList.total > 0" class="space-y-4">
        <Card v-for="item in orderList.records" :key="item.id"
          class="overflow-hidden transition-all duration-300 hover:shadow-lg">
          <!-- Order Header -->
          <CardHeader class="bg-gray-50 dark:bg-slate-700 py-2 flex justify-between items-center text-sm">
            <div class="text-gray-500 dark:text-gray-400">
              订单号：{{ item.number }}
            </div>
          </CardHeader>

          <!-- Order Content -->
          <CardContent class="p-3 flex items-center space-x-3">
            <img class="h-16 w-16 rounded-md object-cover" :src="item.image" alt="商品图片" />
            <div class="flex-grow cursor-pointer" @click="orderDetail(item.id)">
              <h3 class="text-sm font-medium mb-1 line-clamp-1">{{ item.title }}</h3>
              <p class="text-green-600 dark:text-green-400 text-sm font-medium">兑换积分：{{ item.amount }} 积分</p>
            </div>
            <div class="flex items-center space-x-2">
              <Button v-if="item.status === '待发货'" @click="cancel(item.id)" variant="destructive" size="sm">
                取消订单
              </Button>
              <Button v-else-if="item.status === '待收货'" @click="receive(item.id)" variant="default" size="sm">
                确认收货
              </Button>
              <Button v-else-if="item.status === '已完成' || item.status === '待评价'" disabled
                class="bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed text-xs">
                订单已完成
              </Button>
              <Button v-else disabled
                class="bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed text-xs">
                已取消
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>

      <!-- Empty State -->
      <Card v-if="orderList.total === 0 && dataIsLoading != true" class="flex justify-center items-center h-48">
        <CardContent>
          <p class="text-xl font-medium text-gray-500 dark:text-gray-400">暂无积分商品订单</p>
        </CardContent>
      </Card>

      <!-- Pagination -->
      <div class="mt-6 flex justify-center">
        <el-pagination background hide-on-single-page layout="prev, pager, next" :total="orderList.total"
          :current-page="currentPage" :page-size="pageSize" @current-change="currentPageChange"
          class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { Card, CardContent, CardHeader } from '@/components/ui/card'
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Skeleton } from '@/components/ui/skeleton'

import { success } from "@/utils/message"
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import api from "@/utils/api"

const dataIsLoading = ref(false)
const router = useRouter()
const orderStatus = ref('0')
const status = [{ value: '0', name: '全部' }, { value: '2', name: '待发货' }, { value: '3', name: '待收货' }, { value: '6', name: '已完成' }, { value: '5', name: '已取消' }]
const currentPage = ref(1)
const pageSize = ref(10)
const orderList = ref({
  total: 0,
  records: []
})

onMounted(() => {
  getAllOrder()
})

const orderDetail = (id) => {
  router.push({ path: '/orderDetail', query: { id } })
}

/**
 * 取消订单
 * @param id 订单id
 */
const cancel = async (id) => {
  await api({
    url: "/user/order/cancel",
    method: "PUT",
    params: {
      id: id
    }
  }).then(res => {
    if (res.code === 1) {
      success('订单取消成功')
      getAllOrder()
    }
  })
}

/**
 * 收货
 * @param id 订单id
 */
const receive = async (id) => {
  await api({
    url: "/user/order/receive",
    method: "PUT",
    params: {
      id: id
    }
  }).then(res => {
    if (res.code === 1) {
      success('确认收货')
      getAllOrder()
    }
  })
}

const currentPageChange = (page) => {
  currentPage.value = page
  getAllOrder()
}

const getAllOrder = async () => {
  dataIsLoading.value = true
  let data = {
    page: currentPage.value,
    pageSize: pageSize.value,
    status: orderStatus.value === '0' ? null : Number(orderStatus.value),
    title: null,
    buyOrSell: "1",
    productType: "2"
  }
  await api({
    url: '/user/order/page',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    data: data
  }).then(res => {
    if (res.code === 1) {
      orderList.value.total = res.data.total
      orderList.value.records = res.data.records
      //console.log(orderList.value)
    }
  }).finally(() => {
    dataIsLoading.value = false
  })
}

const change = (val) => {
  orderStatus.value = val
  getAllOrder()
}
</script>