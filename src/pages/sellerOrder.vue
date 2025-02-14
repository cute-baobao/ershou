<template>
  <div class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100">
    <div class="container px-[10%] py-6">
      <h1 class="text-2xl font-bold text-center text-green-600 dark:text-green-400 mb-6">卖家中心</h1>

      <!-- Order Status Tabs -->
      <div class="flex items-center justify-center mb-6 bg-white dark:bg-slate-800 rounded-lg shadow-md p-1">
        <button
          v-for="(item, index) in status"
          :key="item"
          @click="active = index"
          class="px-4 py-2 text-sm font-medium rounded-md transition-colors duration-200 ease-in-out"
          :class="[
            active === index
              ? 'bg-green-500 text-white'
              : 'text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700'
          ]"
        >
          {{ item }}
        </button>
      </div>

      <div v-if="dataIsLoading" class="space-y-3">
        <div v-for="i in 5" :key="i" class="bg-white dark:bg-slate-800 rounded-lg overflow-hidden shadow-md">
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
      <div v-if="orderList.total > 0" class="space-y-3">
        <div
          v-for="item in orderList.records"
          :key="item.id"
          class="bg-white dark:bg-slate-800 rounded-lg overflow-hidden shadow-md transition-all duration-300 hover:shadow-lg"
        >
          <!-- Order Header -->
          <div class="bg-gray-50 dark:bg-slate-700 px-4 py-2 flex justify-between items-center text-sm">
            <div @click="router.push({path:'/userDetail',query:{id:item.userId}})" class="flex items-center space-x-2 cursor-pointer">
              <Avatar class="h-6 w-6 border border-green-400 dark:border-green-600">
                <AvatarImage :src="item.avatar" alt="User Avatar" />
                <AvatarFallback>{{ item.username.charAt(0) }}</AvatarFallback>
              </Avatar>
              <span class="font-medium text-green-600 dark:text-green-400">{{ item.username }}</span>
            </div>
            <div class="text-gray-500 dark:text-gray-400">
              订单号：{{ item.number }}
            </div>
          </div>

          <!-- Order Content -->
          <div class="p-3 flex items-center cursor-pointer space-x-3">
            <el-image class="h-16 w-16 rounded-md  object-cover" :src="item.image" alt="宝贝图片" fit="cover" />
            <div class="flex-grow cursor-pointer" @click="orderDetail(item.id)">
              <h3 class="text-sm font-medium mb-1 line-clamp-1">{{ item.title }}</h3>
              <p class="text-green-600 dark:text-green-400 text-sm font-medium">实付款：￥{{ item.amount }}</p>
            </div> 
            <div class="flex items-center space-x-2">
              <trackingItem  @update="getAllOrder" :orderId="item.id" v-if="item.status === '待发货'"/>
              <Button
                v-else-if="item.status === '待支付'"
                disabled
                class="bg-yellow-500 text-black font-medium text-xs cursor-not-allowed"
              >
                等待买家支付
              </Button>
              <Button
                v-else-if="item.status === '待收货'"
                disabled
                class="bg-indigo-500 text-white text-xs cursor-not-allowed"
              >
                等待买家收货
              </Button>
              <Button
                v-else-if="item.status === '已完成'"
                disabled
                class="bg-green-500 text-white text-xs cursor-not-allowed"
              >
                订单已完成
              </Button>
              <Button
                v-else-if="item.status === '待评价'"
                disabled
                class="bg-main dark:bg-main text-black dark:text-gray-700 cursor-not-allowed text-xs"
              >
                等待买家评价
              </Button>
              <Button
                v-else
                disabled
                class="bg-gray-300 dark:bg-gray-600 text-gray-500 dark:text-gray-400 cursor-not-allowed text-xs"
              >
                已取消
              </Button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-if="orderList.total === 0 && dataIsLoading != true" class="flex justify-center items-center h-48 bg-white dark:bg-slate-800 rounded-lg shadow-sm">
        <p class="text-xl font-medium text-gray-500 dark:text-gray-400">暂无订单数据</p>
      </div>

      <!-- Pagination -->
      <div class="mt-6 flex justify-center">
        <el-pagination
          background
          hide-on-single-page
          layout="prev, pager, next"
          :total="orderList.total"
          :current-page="currentPage"
          :page-size="10"
          @current-change="currentPageChange"
          class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Skeleton } from '@/components/ui/skeleton';

import api from '@/utils/api';
import { success } from '@/utils/message'
import { useRouter } from 'vue-router'
import { ref, watch, computed, onMounted } from 'vue';
import trackingItem from '@/components/trackingItem.vue';
//路由管理
const router = useRouter()
// 选项
const active = ref(0);
const currentPage = ref(1)
const status = ref(['所有订单', '待付款', '待发货', '待收货',"已完成",'已取消','待评价'])
const dataIsLoading = ref(false)
const orderList = ref({
    total: 0,
    records: []
})

onMounted(() => {
    getAllOrder()
})

watch(() => active.value, (newValue, oldValue) => {
    currentPage.value = 1
    getAllOrder()
})

const currentPageChange = (val) => {
    currentPage.value = val
    getAllOrder()
}

const getAllOrder = async () => {
    dataIsLoading.value = true
    let status = null
    if (active.value !== 0) {
        status = active.value
    }
    let data = {
        page:currentPage.value,
        pageSize:10,
        status:active.value === 0 ? null : active.value,
        title:null,
        buyOrSell:"2",
        productType:"1"
    }
    await api({
        url: '/user/order/page',
        method: 'POST',
        data: data
    }).then(res => {
        if (res.code === 1) {
            orderList.value.total = res.data.total
            orderList.value.records = res.data.records
        }
    }).finally(() => {
        dataIsLoading.value = false
    })
}

const send = async (id) => {
    await api({
        url: "/user/order/deliver",
        method: "PUT",
        params: {
            id: id
        }
    }).then(res => {
        if (res.code === 1) {
            success('发货成功')
            getAllOrder()
        }
    })
}

const orderDetail = (id)=> {
  router.push({
    path:'/orderDetail',
    query:{
      buyOrSell:2,
      id:id
    }
  })
}

const detail = async(id)=> {
     router.push({
        path: '/detail',
        query:{
            productId:id
        }
    })
}
</script>

<style scoped>
.active {
    color: #34d399;
    border-color: #34d399;
}
</style>
