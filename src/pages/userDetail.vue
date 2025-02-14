<template>
  <div class="min-h-screen bg-slate-200  dark:bg-slate-900 text-gray-900 dark:text-gray-100">
    <div class="container mx-auto px-4 py-8">
      <div class="flex flex-col lg:flex-row gap-8">
        <!-- 左侧：头像、姓名和商品 -->
        <div class="lg:w-2/3">
          <!-- 头像和姓名 -->
          <div class="flex items-center justify-between mb-8">
            <div class="flex items-center">
              <Avatar class="lg:w-24 lg:h-24 md:w-20 md:h-20 sm:w-16 sm:h-16 h-12 w-12 mr-2 md:mr-6 sm:mr-4">
                <AvatarImage :src="user.avatar" :alt="user.username" />
                <AvatarFallback>{{ user.username }}</AvatarFallback>
              </Avatar>
              <div>
                <h1 class="text-md sm:text-lg md:text-xl lg:text-2xl font-bold">{{ user.username }}</h1>
                <p class="text-gray-600 hidden sm:hidden md:block dark:text-gray-400">{{ user.account }}</p>
              </div>
            </div>
            <Button @click="chat"
              class="flex-shrink-0 bg-blue-500 hover:bg-blue-600 text-white transition-colors duration-300 flex items-center justify-center py-2 text-lg">
              <MessageCircle class="w-6 h-6 mr-2" />
              联系Ta
            </Button>
          </div>

          <h2 class="text-2xl font-semibold mb-4">闲置宝贝</h2>
          <!-- 用户发布的商品 -->
          <div v-if="dataIsLoading" class="grid grid-cols-2 md:grid-cols-3 gap-6">
            <div v-for="i in 6" :key="i"
              class="relative bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden">
              <Skeleton class="w-full h-48" />
              <div class="p-4 space-y-2">
                <Skeleton class="h-4 w-3/4" />
                <Skeleton class="h-4 w-1/2" />
                <Skeleton class="h-6 w-1/3" />
              </div>
            </div>
          </div>
          <div v-if="products.length > 0">
            <div class="grid grid-cols-2 md:grid-cols-3 gap-6">
              <productCard :product="item" v-for="item in products" :key="item.image">
                <template v-if="item.isSaled === 1" #status>
                  <div
                    class="absolute w-24 h-24 font-semibold flex justify-center items-center rounded-full bg-gray-500 opacity-75 left-1/2 top-1/2 transform translate-x-[-50%] translate-y-[-50%] rotate-45 text-xl">
                    已售出
                  </div>
                </template>
              </productCard>
            </div>
          </div>
          <div v-if="products.length === 0 && !dataIsLoading"
            class=" flex justify-center p-2 text-5xl font-semibold text-main h-[300px] items-center">空空如也
          </div>
        </div>


        <!-- 右侧：用户评价和评分 -->
        <div class="lg:w-1/3">
          <UserRate  :userId="userId" :rate="user.rate" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar'
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from '@/components/ui/card'
import productCard from '@/components/productCard.vue';
import UserRate from '@/components/UserRate.vue';
import { Skeleton } from '@/components/ui/skeleton';

import { Button } from '@/components/ui/button';
import api from '@/utils/api';
import { Star, MessageCircle } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useUser } from "@/utils/pinia"
import { warning } from "@/utils/message"

const dataIsLoading = ref(false)
const router = useRouter()
const route = useRoute()
const userId = ref(-1)

watch(route,(o,v)=>{
  if(v.query.id) {
    userId.value = Number(v.query.id)
    getUser()
    getProducts()
    window.scrollTo(0, 0)
  }
})

onMounted(() => {
  if (route.query.id) {
    userId.value = Number(route.query.id)
    getUser()
    getProducts()
    window.scrollTo(0, 0)
  }
})
const user1 = useUser()
const user = ref({
  account: '',
  username: '',
  avatar: '',
})
const products = ref([])

const getUser = async () => {
  await api({
    method: 'GET',
    url: "/user/user/get",
    params: {
      id: userId.value
    }
  }).then(res => {
    user.value = res.data
  })
}

const getProducts = async () => {
  dataIsLoading.value = true
  await api({
    url: "/user/product/allPublished",
    method: "GET",
    params: {
      userId: userId.value
    }
  }).then(res => {
    products.value = res.data
    //console.log(products.value)
    products.value = product()
  }).finally(() => dataIsLoading.value = false)
}

const product = () => {
  if (products.value === null)
    return []
  else
    return products.value.filter(item => item.statusMessage === '审核通过')
      .map(item => item)
}

const chat = ()=> {
    if(userId.value === user1.getUser().id) {
        warning('不需要和自己聊天哦')
        return
    }
    router.push({
        path:'/chat',
        query:{
            toUserId:userId.value
        }
    })
}

</script>