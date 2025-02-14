<template>
  <div
    class="min-h-screen bg-gradient-to-br from-blue-400 via-teal-300 to-green-300 dark:from-slate-900 dark:via-teal-900 dark:to-green-900 text-gray-900 dark:text-gray-100 relative overflow-hidden">
    <!-- 背景装饰元素 -->
    <div class="absolute inset-0 z-0 opacity-20">
      <svg class="absolute top-0 left-0 w-full h-full" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
        <path fill="#4ade80" fill-opacity="1"
          d="M0,224L48,213.3C96,203,192,181,288,181.3C384,181,480,203,576,224C672,245,768,267,864,261.3C960,256,1056,224,1152,213.3C1248,203,1344,213,1392,218.7L1440,224L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z">
        </path>
      </svg>
    </div>

    <div class="container mx-auto px-4 py-8 relative z-10">
      <header class="text-center mb-12">
        <h1 class="text-5xl font-bold mb-4 text-blue-600 dark:text-green-300 drop-shadow-lg">绿色积分商城</h1>
        <p class="text-xl text-blue-600 dark:text-green-200 max-w-2xl mx-auto drop-shadow">
          用您的环保行动换取绿色奖励，共同建设可持续发展的未来
        </p>
      </header>

      <div
        class="mb-12 bg-white bg-opacity-90 dark:bg-slate-800 dark:bg-opacity-90 rounded-lg shadow-2xl p-6 relative overflow-hidden backdrop-blur-sm">
        <div
          class="absolute top-0 right-0 w-40 h-40 bg-green-400 dark:bg-green-600 rounded-full -mr-20 -mt-20 opacity-50">
        </div>
        <div class="relative z-10">
          <h2 class="text-2xl font-semibold mb-4 text-green-700 dark:text-green-300">您的碳积分</h2>
          <div class="flex items-center justify-between">
            <span v-if="userPoints !== -1" class="text-5xl font-bold text-green-600 dark:text-green-400">{{ userPoints
              }}</span>
            <span v-else class="text-5xl font-bold text-green-600 dark:text-green-400">--</span>
            <Button @click="earnPoints"
              class="bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-full transition duration-300 ease-in-out transform shadow-lg">
              赚取更多积分
            </Button>
          </div>
        </div>
      </div>

      <div v-if="dataIsLoading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <Card v-for="i in 8" :key="i"
          class="bg-white bg-opacity-90 dark:bg-slate-800 dark:bg-opacity-90 overflow-hidden transition duration-300 ease-in-out backdrop-blur-sm">
          <Skeleton class="w-full h-48" />
          <CardContent>
            <Skeleton class="h-4 w-3/4 mb-2" />
            <Skeleton class="h-4 w-full mb-4" />
            <Skeleton class="h-4 w-full mb-2" />
            <div class="flex justify-between items-center">
              <Skeleton class="h-8 w-1/3" />
              <Skeleton class="h-10 w-1/3 rounded-full" />
            </div>
          </CardContent>
        </Card>
      </div>
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <Card v-for="(product, index) in pointProduct.records" :key="product.id"
          class="bg-white bg-opacity-90 dark:bg-slate-800 dark:bg-opacity-90 overflow-hidden transition duration-300 ease-in-out transform hover:shadow-2xl backdrop-blur-sm">
          <el-image :z-index="3000" :preview-teleported="true" :src="product.image" :alt="product.title"
            class="w-full h-48" fit="contain" :preview-src-list="imgList" :initial-index="index" />
          <CardContent>
            <span class="text-xl font-semibold text-green-700 dark:text-green-300">{{ product.title }}</span>
            <TooltipProvider>
              <Tooltip :delayDuration="300">
                <TooltipTrigger asChild>
                  <p
                    class="text-sm text-black dark:text-green-400 mb-4 line-clamp-2 overflow-hidden text-ellipsis hover:cursor-pointer">
                    {{ product.desc }}
                  </p>
                </TooltipTrigger>
                <TooltipContent class="h-fit max-w-xs">
                  <p>{{ product.desc }}</p>
                </TooltipContent>
              </Tooltip>
            </TooltipProvider>
            <div class="flex justify-between items-center">
              <span class="text-2xl font-bold text-orange-500 dark:text-green-400">{{ product.pointsPrice }} 积分</span>
              <Button @click="redeemProduct(product)" :disabled="userPoints < product.pointsPrice"
                class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-full disabled:bg-gray-400 disabled:cursor-not-allowed transition duration-300 ease-in-out shadow-md">
                兑换
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
      <div class="mt-6 flex justify-center">
        <el-pagination background hide-on-single-page layout="prev, pager, next" :total="pointProduct.total"
          :current-page="page" :page-size="8" @current-change="currentPageChange"
          class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm" />
      </div>
      <section
        class="mt-16 bg-emerald-600 dark:bg-emerald-800 rounded-lg p-8 text-center relative overflow-hidden shadow-2xl">
        <div class="absolute inset-0 z-0 opacity-20">
          <svg class="absolute bottom-0 left-0 w-full h-1/2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
            <path fill="#ffffff" fill-opacity="1"
              d="M0,64L48,80C96,96,192,128,288,128C384,128,480,96,576,90.7C672,85,768,107,864,128C960,149,1056,171,1152,165.3C1248,160,1344,128,1392,112L1440,96L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z">
            </path>
          </svg>
        </div>
        <div class="relative z-10">
          <h2 class="text-3xl font-bold mb-10 text-white dark:text-green-200">我们的环保宣言</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="flex flex-col items-center">
              <div
                class="w-24 h-24 mb-6 bg-white dark:bg-green-700 rounded-full flex items-center justify-center shadow-lg">
                <svg class="w-12 h-12 text-emerald-600 dark:text-green-200" fill="none" stroke="currentColor"
                  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z">
                  </path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white dark:text-green-200">减少碳足迹</h3>
              <p class="text-green-100 dark:text-green-300">每一个小行动都能为地球减少碳排放，让我们共同努力。</p>
            </div>
            <div class="flex flex-col items-center">
              <div
                class="w-24 h-24 mb-6 bg-white dark:bg-green-700 rounded-full flex items-center justify-center shadow-lg">
                <svg class="w-12 h-12 text-emerald-600 dark:text-green-200" fill="none" stroke="currentColor"
                  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15">
                  </path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white dark:text-green-200">循环利用</h3>
              <p class="text-green-100 dark:text-green-300">提倡资源的循环利用，减少浪费，保护地球资源。</p>
            </div>
            <div class="flex flex-col items-center">
              <div
                class="w-24 h-24 mb-6 bg-white dark:bg-green-700 rounded-full flex items-center justify-center shadow-lg">
                <svg class="w-12 h-12 text-emerald-600 dark:text-green-200" fill="none" stroke="currentColor"
                  viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path>
                </svg>
              </div>
              <h3 class="text-xl font-semibold mb-2 text-white dark:text-green-200">绿化地球</h3>
              <p class="text-green-100 dark:text-green-300">种树造林，增加绿地面积，为地球增添生机。</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider } from '@/components/ui/tooltip'
import { Skeleton } from '@/components/ui/skeleton'

import { onMounted, ref } from 'vue'
import { useToken, useUser } from "@/utils/pinia"
import api from "@/utils/api"
import { useRouter } from 'vue-router'
import { info } from "@/utils/message"
 
const router = useRouter()
const userPoints = ref(-1)
const token = useToken()
const user = useUser()
const page = ref(1)
const pageSize = ref(8)
const imgList = ref([])
const dataIsLoading = ref(false)
const pointProduct = ref({
  total: 10,
  records: []
})

const products = ref([
  {
    id: 1,
    name: '环保购物袋',
    description: '可重复使用的环保购物袋，减少塑料袋使用。',
    points: 200,
    image: '/placeholder.svg?height=200&width=300'
  },
  {
    id: 2,
    name: '节能LED灯泡',
    description: '高效节能的LED灯泡，降低能源消耗。',
    points: 300,
    image: '/placeholder.svg?height=200&width=300'
  },
  {
    id: 3,
    name: '可回收水杯',
    description: '环保材质制作的可回收水杯，减少一次性杯子使用。',
    points: 250,
    image: '/placeholder.svg?height=200&width=300'
  },
  {
    id: 4,
    name: '太阳能充电宝',
    description: '使用太阳能充电的便携式充电宝，绿色环保。',
    points: 500,
    image: '/placeholder.svg?height=200&width=300'
  },
  {
    id: 5,
    name: '有机棉T恤',
    description: '使用有机棉制作的环保T恤，舒适且环保。',
    points: 400,
    image: '/placeholder.svg?height=200&width=300'
  },
  {
    id: 6,
    name: '自行车维修券',
    description: '鼓励使用自行车出行，提供免费维修服务。',
    points: 350,
    image: '/placeholder.svg?height=200&width=300'
  }
])

onMounted(() => {
  getPoint()
  getPointProduct()
})
const earnPoints = () => {
  info("交易二手物品可以获得积分哦！")
}

const redeemProduct = (product) => {
  router.push({
    path: '/pointOrder',
    query: {
      id: product.id
    }
  })
}

const getPoint = () => {
  if (token.getToken() === '')
    return
  api({
    url: "/user/user/getPoint",
    method: "GET",
    params: {
      id: user.getUser().id
    }
  }).then(res => {
    userPoints.value = res.data
  })
}

const getPointProduct = () => {
  dataIsLoading.value = true
  api({
    url: "/user/pointsProduct/page",
    method: "GET",
    params: {
      page: page.value,
      pageSize: pageSize.value,
      title: null,
      categoryId: null
    }
  }).then(res => {
    ////console.log(res.data)
    pointProduct.value.total = res.data.total;
    pointProduct.value.records = res.data.records
    pointProduct.value.records.forEach(item => imgList.value.push(item.image))
  }).finally(() => {
    dataIsLoading.value = false
  })
}

const currentPageChange = (val) => {
  page.value = val
  getPointProduct()
}
</script>