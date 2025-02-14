<template>
    <Dialog>
        <DialogTrigger>
            <Button class="bg-gray-50" variant="outline">查看更多</Button>
        </DialogTrigger>
        <DialogContent class=" grid-rows-[auto_minmax(0,1fr)_auto] p-0 max-h-[70dvh] w-full max-w-[60%]">
            <DialogHeader class="p-6 pb-0">
                <DialogTitle>全部商品</DialogTitle>
                <DialogDescription>
                    您发布的全部商品
                </DialogDescription>
            </DialogHeader>
            <div class="overflow-y-auto grid gap-4 py-4 px-6 scroll-smooth">
                <div class="space-y-4" v-if="products.length > 0">
                    <div v-for="(item, index) in products" :key="item.productId"
                        class="flex items-center bg-gray-50 max-w-[56.5svw] dark:bg-slate-800 border relative border-gray-200 dark:border-slate-700 rounded-lg p-3 shadow-sm hover:shadow-md transition-all duration-300"
                        :class="{ 'bg-gray-100 dark:bg-slate-700': item.isSaled === 1 || item.statusMessage !== '审核通过' }">
                        <el-image class="h-16 w-16 object-cover rounded-md mr-3 flex-shrink-0" :src="item.image"
                            alt="宝贝封面" fit="cover" :preview-src-list="imgList" :initial-index="index" />
                        <div class="flex-grow min-w-0 cursor-pointer" @click="item.statusMessage === '审核不通过' ?  remark(item.remark) : detail(item.productId) ">
                            <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">
                                {{ item.title }}
                            </p>
                            <p class="text-xs text-gray-600 dark:text-gray-400 mt-1">
                                价格：￥{{ item.price }}
                            </p>
                        </div>
                        <div class="flex items-center ml-2 flex-shrink-0">
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button variant="outline" size="sm"
                                        class="text-xs px-2 bg-white dark:bg-slate-700 text-gray-800 dark:text-gray-200 border-gray-300 dark:border-slate-600">
                                        更多操作
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent>
                                    <DropdownMenuGroup>
                                        <DropdownMenuItem @click="detail(item.productId)">
                                            详情
                                        </DropdownMenuItem>
                                        <DropdownMenuItem :disabled="item.isSaled == 1" @click="update(item.productId)">
                                            修改商品
                                        </DropdownMenuItem>
                                        <DropdownMenuItem v-if="item.statusMessage === '审核不通过' || item.statusMessage === '发布成功'" :disabled="item.isSaled == 1" @click="del(item.productId)">
                                            删除商品
                                        </DropdownMenuItem>
                                        <DropdownMenuItem v-if="item.statusMessage === '审核不通过'" @click="remark(item.remark)">
                                            查看审核结果
                                        </DropdownMenuItem>
                                        <DropdownMenuItem v-if="item.statusMessage === '审核通过'" :disabled="item.isSaled == 1" @click="cancel(item.productId)">
                                            下架商品
                                        </DropdownMenuItem>
                                    </DropdownMenuGroup>
                                </DropdownMenuContent>
                            </DropdownMenu>
                        </div>
                        <div v-if="item.isSaled === 1"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-orange-500 text-white text-xs font-bold rounded-br-lg shadow-md">
                            已售出
                        </div>
                        <div v-else-if="item.statusMessage === '审核不通过'"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-red-500 text-white text-xs font-bold rounded-br-lg shadow-md">
                            审核未通过
                        </div>
                        <div v-else-if="item.statusMessage === '发布成功'"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-yellow-400 text-gray-800 text-xs font-bold rounded-br-lg shadow-md">
                            待审核
                        </div>
                    </div>
                </div>
                <div v-else
                    class="flex justify-center items-center h-40 text-xl font-semibold text-gray-500 dark:text-gray-400">
                    暂无商品
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
    DropdownMenuGroup
} from '@/components/ui/dropdown-menu'

import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { useRouter } from 'vue-router';
import { data } from 'autoprefixer';

const emits = defineEmits(['update'])
//状态管理
const user = useUser()
//路由管理
const router = useRouter()
//页面数据
const products = ref([])
const imgList = ref([])
onMounted(() => {
    getProduct()
})
const getProduct = async () => {
    await api({
        url: '/user/product/allPublished',
        method: 'GET',
        params: {
            userId: user.getUser().id
        }
    }).then(res => {
        products.value = res.data
        if (products.value != null) {
            products.value.map(item => {
                imgList.value.push(item.image)
            })
        } else
            products.value = []
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

const update = async (id) => {
    router.push({
        path: '/update',
        query: {
            id: id
        }
    })
}

const cancel = async (id) => {
    await api({
        url: '/user/product/delete',
        method: 'PUT',
        params: {
            id: id
        }
    }).then(res => {
        if (res.code === 1) {
            emits('update')
            success('下架商品成功')
            getProduct()
        }
    })
}
const remark = (remark) => {
  router.push({
    path: '/fail',
    query: {
      remark: remark
    }
  })
}

const del = (id) => {
    api({
        url:"/user/product/delete",
        method:"DELETE",
        params:{
            id:id
        }
    }).then(res=>{
        emits('update')
        success('删除商品成功')
        getProduct()
    })
}
</script>

<style scoped></style>