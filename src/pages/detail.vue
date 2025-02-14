<template>
  <div ref="contain"
    class="min-h-screen bg-gray-100 dark:bg-slate-950 text-gray-900 dark:text-gray-100 py-8 px-4 sm:px-6 lg:px-8">
    <div class="max-w-7xl mx-auto">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- 左侧：商品图片和详细信息 -->
        <div class="lg:col-span-2 space-y-6">
          <!-- 商品图片轮播 -->
          <div class="bg-white dark:bg-slate-900 rounded-lg shadow-lg overflow-hidden">
            <Skeleton v-if="loading" class="w-full h-[400px]" />
            <el-carousel v-else :interval="5000" arrow="always" height="400px" class="rounded-lg">
              <el-carousel-item v-for="(image, index) in product.image" :key="index">
                <el-image :preview-teleported="true" :src="image" fit="contain" class="w-full h-full"
                  :preview-src-list="product.image" :initial-index="index" />
              </el-carousel-item>
            </el-carousel>
          </div>

          <!-- 商品详情卡片 -->
          <Card class="bg-white dark:bg-slate-900 shadow-md">
            <CardHeader>
              <CardTitle class="space-y-4">
                <div class="flex items-center justify-between">
                  <span
                    class="text-sm font-semibold text-green-600 dark:text-green-400 uppercase tracking-wide flex items-center">
                    <Recycle class="w-5 h-5 mr-2" />
                    个人闲置
                  </span>
                  <div class="text-lg text-red-500 dark:text-red-400 flex items-center">
                    <Heart class="w-5 h-5 mr-1" />
                    <Skeleton v-if="loading" class="h-6 w-16 inline-block" />
                    <span v-else>{{ product.collectionNum }} 人想要</span>
                  </div>
                </div>
                <Skeleton v-if="loading" class="h-9 w-3/4" />
                <h1 v-else class="text-3xl font-bold text-gray-800 dark:text-gray-200">{{ product.title }}</h1>
              </CardTitle>
              <CardDescription>
                <div class="flex justify-between items-end mt-4">
                  <div class="space-y-2">
                    <div class="text-3xl font-bold text-green-600 dark:text-green-400 flex items-center">
                      <Skeleton v-if="loading" class="h-8 w-24" />
                      <div class="flex items-center" v-else>
                        ￥{{ product.price }}
                      </div>
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400 flex items-center">
                      <Truck class="w-4 h-4 mr-1" />
                      运费: ￥{{ product.freight }}
                    </div>
                  </div>
                </div>
                <div
                  class="mt-4 flex items-center text-green-600 dark:text-green-400 bg-green-100 dark:bg-green-900 p-3 rounded-md">
                  <Leaf class="h-6 w-6 mr-3 flex-shrink-0" />
                  <span class="text-sm">通过购买闲置宝贝，您将减少约 {{ product.carbonReduction }}kg 的碳排放</span>
                </div>
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div class="space-y-6">
                <div>
                  <h2 class="text-xl font-semibold mb-3 text-gray-800 dark:text-gray-200 flex items-center">
                    <FileText class="w-5 h-5 mr-2 text-green-500 dark:text-green-400" />
                    宝贝描述
                  </h2>
                  <Skeleton v-if="loading" class="h-20 w-full" />
                  <p v-else class="text-gray-700 dark:text-gray-300 text-sm leading-relaxed">{{ product.desc }}</p>
                </div>
                <div>
                  <h2 class="text-xl font-semibold mb-3 text-gray-800 dark:text-gray-200 flex items-center">
                    <Lightbulb class="w-5 h-5 mr-2 text-green-500 dark:text-green-400" />
                    环保贴士
                  </h2>
                  <ul class="space-y-2 text-gray-700 dark:text-gray-300 text-sm">
                    <li class="flex items-start">
                      <CheckCircle2 class="w-5 h-5 mr-2 text-green-500 dark:text-green-400 flex-shrink-0 mt-0.5" />
                      <span>购买闲置宝贝可以延长物品的使用寿命，减少废弃物</span>
                    </li>
                    <li class="flex items-start">
                      <MapPin class="w-5 h-5 mr-2 text-green-500 dark:text-green-400 flex-shrink-0 mt-0.5" />
                      <span>选择本地卖家可以减少运输过程中的碳排放</span>
                    </li>
                    <li class="flex items-start">
                      <Package class="w-5 h-5 mr-2 text-green-500 dark:text-green-400 flex-shrink-0 mt-0.5" />
                      <span>考虑使用环保包装或自带容器取货，进一步减少包装废弃物</span>
                    </li>
                  </ul>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <!-- 右侧：卖家信息和操作按钮 -->
        <div class="lg:col-span-1">
          <div class="sticky top-6 space-y-6">
            <!-- 卖家信息卡片 -->
            <Card class="bg-white dark:bg-slate-900 shadow-md">
              <CardHeader>
                <CardTitle class="flex items-center space-x-4">
                  <Skeleton v-if="loading" class="h-16 w-16 rounded-full" />
                  <Avatar v-else @click="userDetail"
                    class="h-16 w-16 cursor-pointer ring-2 ring-green-500 dark:ring-green-400">
                    <AvatarImage :src="product.avatar" :alt="product.username" />
                    <AvatarFallback>{{ product.username[0] }}</AvatarFallback>
                  </Avatar>
                  <div class="flex-1">
                    <h3 class="text-xl font-bold text-gray-800 dark:text-gray-200 flex items-center">
                      <Skeleton v-if="loading" class="h-7 w-32" />
                      <template v-else>
                        <User class="w-5 h-5 mr-2 text-green-500 dark:text-green-400" />
                        {{ product.username }}
                      </template>
                    </h3>
                    <CardDescription class="mt-1 flex items-center">
                      <div class="flex items-center">
                        <Star class="w-5 h-5 mr-2 text-yellow-500" />
                        <span class="text-sm text-gray-600 dark:text-gray-400">卖家评分：</span>
                      </div>
                      <Skeleton v-if="loading" class="h-6 w-24 mt-1" />
                      <div v-else>
                        <el-rate v-model="product.rate" text-color="#ff9900" disabled />
                      </div>
                    </CardDescription>
                  </div>
                </CardTitle>
              </CardHeader>
            </Card>

            <!-- 操作按钮 -->
            <Card class="bg-white dark:bg-slate-900 shadow-md relative">
              <div v-if="product.isSaled === 1 || product.status === 0"
                class="absolute inset-0 bg-gray-900 bg-opacity-70 flex items-center justify-center z-10 rounded-lg">
                <div class="text-white text-center">
                  <AlertCircle class="w-12 h-12 mx-auto mb-2" />
                  <p class="text-lg font-semibold">商品{{ product.status == 0 ? "正在审核中" : "已下架" }}</p>
                  <p class="text-sm">该商品当前无法购买</p>
                  <Button v-if="product.collectionStatus" :disabled="!product.collectionStatus"
                    @click="cancelCollect()" :class="{
                      'bg-gray-500 hover:bg-gray-600': product.collectionStatus,
                    }"
                    class="w-full text-white transition-colors duration-300 flex items-center justify-center py-2 text-lg mt-2">
                    <BookmarkMinus class="w-6 h-6 mr-2" />
                    取消收藏
                  </Button>
                </div>
              </div>
              <CardContent class="space-y-4 py-6">
                <Skeleton v-if="loading" class="h-12 w-full" />
                <Button v-else :disabled="product.isSaled === 1 || product.status === 0"
                  @click="product.collectionStatus ? cancelCollect() : collect()" :class="{
                    'bg-gray-500 hover:bg-gray-600': product.collectionStatus,
                    'bg-blue-500 hover:bg-blue-600': !product.collectionStatus
                  }"
                  class="w-full text-white transition-colors duration-300 flex items-center justify-center py-2 text-lg">
                  <BookmarkPlus v-if="!product.collectionStatus" class="w-6 h-6 mr-2" />
                  <BookmarkMinus v-else class="w-6 h-6 mr-2" />
                  {{ product.collectionStatus ? '取消收藏' : '收藏' }}
                </Button>
                <Skeleton v-if="loading" class="h-12 w-full" />
                <Button v-else :disabled="product.isSaled === 1 || product.status === 0" @click="buy"
                  class="w-full bg-green-500 hover:bg-green-600 text-white transition-colors duration-300 flex items-center justify-center py-2 text-lg">
                  <ShoppingCart class="w-6 h-6 mr-2" />
                  直接购买
                </Button>
                <Skeleton v-if="loading" class="h-12 w-full" />
                <Button v-else @click="chat"
                  class="w-full bg-blue-500 hover:bg-blue-600 text-white transition-colors duration-300 flex items-center justify-center py-2 text-lg">
                  <MessageCircle class="w-6 h-6 mr-2" />
                  联系卖家
                </Button>
              </CardContent>
            </Card>

            <!-- 商品评论卡片 -->
            <ProductRate :id="Number(route.query.productId)" :loading="loading" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import Button from '@/components/ui/button/Button.vue'
import Header from '@/components/Header.vue'
import {
  Recycle, DollarSign, Truck, Heart, Leaf, FileText, Lightbulb,
  CheckCircle2, MapPin, Package, User, Star, BookmarkPlus,
  BookmarkMinus, ShoppingCart, MessageCircle, ArrowLeft,AlertCircle
} from 'lucide-vue-next'
import { Skeleton } from '@/components/ui/skeleton'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import ProductRate from "@/components/ProductRate.vue"

import { onMounted, ref, computed, watch, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '@/utils/api'
import { success, warning } from '@/utils/message'
import { useToken, useUser } from '@/utils/pinia'

const contain = ref(null)
const route = useRoute()
const router = useRouter()
const id = ref(-1)
const loading = ref(false)
const token = useToken()
const user = useUser()
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
  collectionStatus: Number
})


onMounted(async () => {
  if (route.query.productId) {
    id.value = Number(route.query.productId)
    await loadProduct().catch(err => {
        router.push({ path: '/404' })
    })
    
    if (product.value.status === 2) {
      router.push("/fail")
    }
    document.title = product.value.title + " | 小碳二手交易平台"
  }
  window.scrollTo(0, 0)
})

onUnmounted(() => {
  document.title = "小碳二手交易平台"
})
const loadProduct = async () => {
  loading.value = true
  if (id.value === -1)
    router.push({ path: '/' })
  await api({
    url: '/user/product/detail',
    method: 'GET',
    params: {
      productId: id.value,
      userId: token.getToken() === '' ? null : user.getUser().id
    }
  }).then(res => {
    product.value = { ...res.data }
    //console.log(product.value)
  }).finally(() => { loading.value = false })
}

const collect = () => {
  if (token.getToken() === '') {
    router.push({
      path: '/login',
      query: {
        msg: '登陆后才能进行收藏操作'
      }
    })
    return
  }
  api({
    url: '/user/product/collect',
    method: 'POST',
    params: {
      id: id.value
    }
  }).then(res => {
    if (res.code === 1) {
      product.value.collectionStatus = 1
      product.value.collectionNum++
      success('收藏成功')
    } else {
      warning('收藏失败')
    }
  })
}

const cancelCollect = () => {
  api({
    url: '/user/product/cancelCollect',
    method: 'POST',
    params: {
      id: id.value
    }
  }).then(res => {
    if (res.code === 1) {
      product.value.collectionStatus = 0
      product.value.collectionNum--
      success('取消收藏成功')
    } else {
      warning('取消收藏失败')
    }
  })
}

const buy = () => {
  if (product.value.userId === user.getUser().id) {
    warning('无法购买自己发布的宝贝')
    return
  }
  router.push({
    path: '/order',
    query: {
      id: id.value
    }
  })
}

const userDetail = () => {
  router.push({
    path: '/userDetail',
    query: {
      id: product.value.userId
    }
  })
}

const chat = () => {
  if (product.value.userId === user.getUser().id) {
    warning('不需要和自己聊天哦')
    return
  }
  router.push({
    path: '/chat',
    query: {
      toUserId: product.value.userId
    }
  })
}
</script>