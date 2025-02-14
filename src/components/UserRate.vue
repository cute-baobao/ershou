<template>
    <Card class="sticky top-8 max-h-[50svh]">
        <CardHeader class="flex flex-row items-center justify-between">
            <CardTitle>用户评价</CardTitle>
            <el-rate v-model="props.rate" show-score text-color="#ff9900"
                :score-template="props.rate === 0 ? '暂无评分' : props.rate + '/5'" disabled />
        </CardHeader>
        <CardContent class="space-y-4 overflow-y-auto">
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
            <div v-else-if="reviews.total === 0" class="flex flex-col items-center justify-center py-8">
                <InboxIcon class="w-12 h-12 text-gray-400 dark:text-gray-600 mb-4" />
                <p class="text-lg font-medium text-gray-600 dark:text-gray-400">暂无评论</p>
                <p class="text-sm text-gray-500 dark:text-gray-500 mt-2">成为第一个评论这个商品的人吧！</p>
            </div>
            <div v-else v-for="review in reviews.records" :key="review.id"
                class="border-b border-gray-200 dark:border-gray-700 last:border-b-0 pb-4 last:pb-0">
                <div class="flex justify-between items-center mb-2">
                    <div class="flex items-center gap-1">
                        <Avatar class="w-8 h-8 mr-2">
                            <AvatarImage :src="review.avatar" :alt="review.name" />
                            <AvatarFallback>{{ "TX" }}</AvatarFallback>
                        </Avatar>
                        <span class="font-semibold">{{ review.username }}</span>
                    </div>
                    <div class="flex items-center mb-2">
                        <span class="text-gray-500">{{ review.createTime }}</span>
                    </div>
                </div>
                <p class="text-sm text-gray-600 dark:text-gray-400">{{ review.content }}</p>
            </div>
            <div v-if="!loading && reviews.records.length > 0" class="mt-6 flex justify-center">
                <el-pagination
                background
                hide-on-single-page
                layout="prev, pager, next"
                :total="reviews.total"
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
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar'
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'

import { InboxIcon } from "lucide-vue-next"
import { onMounted, ref,watch } from 'vue'
import api from "@/utils/api.js"
const props = defineProps({
    userId: Number,
    rate: Number
})
const loading = ref(false)
const reviews =ref( 
    {
        records: [],
        total: 0
    }
)
const page = ref(1)
const pageSize = ref(5)

watch(()=>props.userId,(newValue,oldValue)=>{
    getComment()
})

const pageChange = (val) => {
    page.value = val
    getComment()
}

const getComment = () => {
    loading.value = true
    api({
        url: "/user/userComments/page",
        method: "GET",
        params: {
            page:page.value,
            pageSize:pageSize.value,
            targetUserId:props.userId,
            status:2
        }
    }).then(res=>{
        reviews.value = res.data
        //console.log(res.data)
    }).finally(()=>{
        loading.value = false
    })
}
</script>