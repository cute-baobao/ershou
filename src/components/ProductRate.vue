<template>
  <!-- 商品评论卡片 -->
  <Card class="bg-white dark:bg-slate-900 shadow-md mt-4">
    <CardHeader class="flex flex-row items-center justify-between">
      <CardTitle class="text-xl font-semibold text-gray-800 dark:text-gray-200">留言</CardTitle>
      <ProductRateItem @update="getComment"/>
    </CardHeader>
    <CardContent class="max-h-[40dvh] overflow-y-auto">
      <div v-if="loading" class="space-y-4">
        <div v-for="i in 3" :key="i" class="flex flex-col space-y-2">
          <div class="flex items-center space-x-2">
            <Skeleton class="h-8 w-8 rounded-full" />
            <Skeleton class="h-4 w-24" />
          </div>
          <Skeleton class="h-4 w-full" />
          <Skeleton class="h-4 w-3/4" />
          <Skeleton class="h-3 w-20" />
        </div>
      </div>
      <div v-else-if="recentReviews.total === 0" class="flex flex-col items-center justify-center py-8">
        <InboxIcon class="w-12 h-12 text-gray-400 dark:text-gray-600 mb-4" />
        <p class="text-lg font-medium text-gray-600 dark:text-gray-400">暂无留言</p>
        <p class="text-sm text-gray-500 dark:text-gray-500 mt-2">成为第一个留言的人吧！</p>
      </div>
      <ul v-else class="space-y-4">
        <li v-for="(review,index) in recentReviews.records" :key="review.id"
            class="border-b border-gray-200 dark:border-gray-700 pb-4 last:border-b-0">
          <div class="flex items-center mb-2">
            <Avatar @click="userDetail(review.userId)" class="h-8 w-8 mr-2 cursor-pointer">
              <AvatarImage :src="review.avatar" :alt="review.username" />
              <AvatarFallback>{{ review.username }}</AvatarFallback>
            </Avatar>
            <span class="font-semibold text-gray-800 dark:text-gray-200">{{ review.username }}</span>
            <div class="ml-auto flex items-center">
              <ThumbsUp @click="review.liked ? cancelLike(review.id,index) : like(review.id,index)"
                        :class="['h-4 w-4 hover:scale-105 cursor-pointer', review.liked ? 'text-green-500' : '']" />
              <span class="mx-1 text-red-400">{{ review.likeNum }}</span>
            </div>
          </div>
          <p class="text-gray-600 dark:text-gray-400">{{ review.content }}</p>
          <span class="text-sm text-gray-500 dark:text-gray-500 flex items-center gap-2">
            <span>{{ review.createTime }}</span>
            <Trash2 class="h-4 w-4 hover:scale-110 hover:text-red-500 cursor-pointer"
              v-if="review.userId === user.id"
              @click="delCommet(review.id)"
            />
          </span>
        </li>
      </ul>
      <div v-if="!loading && recentReviews.records.length > 0" class="mt-6 flex justify-center">
        <el-pagination
          background
          hide-on-single-page
          layout="prev, pager, next"
          :total="recentReviews.total"
          :current-page="page"
          :page-size="pageSize"
          @current-change="pageChange"
          class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm"
        />
      </div>
    </CardContent>
  </Card>
</template>

<script setup>
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar'
import { ThumbsUp,Loader2,InboxIcon,Trash2, Info } from 'lucide-vue-next'
import ProductRateItem from '@/components/ProductRateItem.vue'
import { Skeleton } from '@/components/ui/skeleton'

import { success } from '@/utils/message'
import api from "@/utils/api"
import { useRoute, useRouter } from 'vue-router'
import { onMounted, ref } from 'vue'
import { useUser } from "@/utils/pinia"

const props = defineProps({
    id: { type: Number, default: null }
})
const loading = ref(false)
const recentReviews = ref({total:0,records:[]})
// 获取用户信息
const user = useUser().getUser()
// 分页参数
const page = ref(1)
const pageSize = ref(5)
const waitting = ref(false)
const router = useRouter()
onMounted(()=> {
  getComment()
})

const pageChange = (val) => {
  page.value = val
  getComment()
}

const getComment = () => {
  loading.value = true
    api({
        url:"/user/productComments/page",
        method:"GET",
        params:{
            page:page.value,
            pageSize:5,
            userId:user.id,
            productId:props.id,
            status:2
        }
    }).then(res=>{
      console.log(res.data)
      recentReviews.value = res.data
      console.log(res.data)
    }).finally(()=>{
      loading.value = false
    })
}

const like = (id,index) => {
  recentReviews.value.records[index].liked = true
  api({
    url:"/user/productComments/like",
    method:"PUT",
    params:{
      id:id
    }
  }).then(res => {
    if(res.code === 1) {
      recentReviews.value.records[index].likeNum += 1
    }
  })
}

const cancelLike = (id,index) => {
  recentReviews.value.records[index].liked = false
  api({
    url:"/user/productComments/cancelLike",
    method:"PUT",
    params:{
      id:id
    }
  }).then(res => {
    if(res.code === 1) {
      recentReviews.value.records[index].likeNum -= 1
    }
  })
}

const userDetail = (id)=> {
    router.push({
        path:'/userDetail',
        query:{
            id:id
        }
    })
}

const delCommet = (id,index) => {
  if(waitting.value)
    return Info("稍后再试")
  waitting.value = true
  api({
    url:"/user/productComments/delete",
    method:"DELETE",
    params:{
      id:id
    }
  }).then(res => {
    if(res.code === 1) {
      recentReviews.value.total -= 1
      recentReviews.value.records.splice(index,1)
    }
  }).finally((e)=>{
    waitting.value = false
  })
}
</script>
