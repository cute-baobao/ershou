<template>
    <Dialog>
        <DialogTrigger>
            <Button class="bg-gray-50" variant="outline">查看更多</Button>
        </DialogTrigger>
        <DialogContent class=" grid-rows-[auto_minmax(0,1fr)_auto] p-0 max-h-[70dvh] w-full max-w-[60%]">
            <DialogHeader class="p-6 pb-0">
                <DialogTitle>收藏</DialogTitle>
                <DialogDescription>
                    全部收藏
                </DialogDescription>
            </DialogHeader>
            <div class="overflow-y-auto grid gap-4 py-4 px-6 scroll-smooth">
                <div class="space-y-4" v-if="products.length > 0">
                    <div v-for="(item, index) in products" :key="item.productId"
                        class="flex items-center bg-gray-50 dark:bg-slate-800 border max-w-[56.5svw] relative border-gray-200 dark:border-slate-700 rounded-lg p-3 shadow-sm hover:shadow-md transition-all duration-300"
                        :class="{ 'bg-gray-100 dark:bg-slate-700': item.isSaled === 1 }">
                        <el-image class="h-16 w-16 object-cover rounded-md mr-3 flex-shrink-0" :src="item.image"
                            alt="宝贝封面" fit="cover" :preview-src-list="imgList" :initial-index="index" />
                        <div class="flex-grow min-w-0 cursor-pointer" @click="detail(item.productId)">
                            <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
                                {{ item.title }}
                            </p>
                            <p class="text-xs text-gray-600 dark:text-gray-400 mt-1">
                                价格：￥{{ item.price }}
                            </p>
                        </div>
                        <div class="flex items-center ml-2 flex-shrink-0">
                            <Button variant="outline" @click="cancelCollection(item.productId)"
                                class="text-xs px-2 bg-white dark:bg-slate-700 text-gray-800 dark:text-gray-200 border-gray-300 dark:border-slate-600 hover:bg-gray-100 dark:hover:bg-slate-600">
                                取消收藏
                            </Button>
                        </div>
                        <div v-if="item.isSaled === 1"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-gray-500 text-white text-xs font-bold rounded-br-lg shadow-md">
                            已失效
                        </div>
                    </div>
                </div>
                <div v-else
                    class="flex justify-center items-center h-40 text-xl font-semibold text-gray-500 dark:text-gray-400">
                    暂无收藏商品
                </div>
            </div>
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
} from '@/components/ui/dialog'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'

import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { useRouter } from 'vue-router';

const emits = defineEmits(['update'])
// 引入路由
const router = useRouter()
// 页面数据
const products = ref([])
const imgList = ref([])

onMounted(() => {
    getCollection()
})
const getCollection = async () => {
    await api({
        url: '/user/product/allCollections',
        method: 'GET',
    }).then(res => {
        if (res.data != null) {
            products.value = res.data
            products.value.map(item => {
                imgList.value.push(item.image)
            })
        } else {
            products.value = []
        }
    })
}

const detail = async (id) => {
    router.push({
        path: '/detail',
        query: {
            productId: id
        }
    })
}

const cancelCollection = (id) => {
    api({
        url: '/user/product/cancelCollect',
        method: 'POST',
        params: {
            id: id
        }
    }).then(res => {
        if (res.code === 1) {
            emits('update')
            success('取消收藏成功')
            getCollection()
        }
    })
}
</script>

<style scoped></style>