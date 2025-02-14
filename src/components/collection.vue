<template>
    <div>
        <Card class="bg-white dark:bg-slate-900">
            <CardHeader class="space-y-2">
                <CardTitle class="flex justify-between items-center">
                    <span
                        class="text-xl sm:text-2xl font-bold text-gray-800 dark:text-gray-200"
                        >我的收藏</span
                    >
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div class="space-y-4 overflow-y-auto scroll-smooth max-h-[40svh]" v-if="products.length > 0">
                    <div
                        v-for="(item, index) in products"
                        :key="item.productId"
                        class="flex items-center bg-gray-50 dark:bg-slate-800 border relative border-gray-200 dark:border-slate-700 rounded-lg p-3 shadow-sm hover:shadow-md transition-all duration-300"
                        :class="{
                            'bg-gray-100 dark:bg-slate-700': item.isSaled === 1,
                        }"
                    >
                        <el-image
                            class="h-16 w-16 object-cover rounded-md mr-3 flex-shrink-0"
                            :src="item.image"
                            alt="宝贝封面"
                            fit="cover"
                            :preview-src-list="imgList"
                            :initial-index="index"
                        />
                        <div
                            class="flex-grow min-w-0 cursor-pointer"
                            @click="detail(item.productId)"
                        >
                            <p
                                class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate"
                            >
                                {{ item.title }}
                            </p>
                            <p
                                class="text-xs text-gray-600 dark:text-gray-400 mt-1"
                            >
                                价格：￥{{ item.price }}
                            </p>
                        </div>
                        <div class="flex items-center ml-2 flex-shrink-0">
                            <Button
                                variant="outline"
                                @click="cancelCollection(item.productId)"
                                class="text-xs px-2 bg-white dark:bg-slate-700 text-gray-800 dark:text-gray-200 border-gray-300 dark:border-slate-600 hover:bg-gray-100 dark:hover:bg-slate-600"
                            >
                                取消收藏
                            </Button>
                        </div>
                        <div
                            v-if="item.isSaled === 1"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-gray-500 text-white text-xs font-bold rounded-br-lg shadow-md"
                        >
                            已失效
                        </div>
                    </div>
                </div>
                <div
                    v-else
                    class="flex justify-center items-center h-40 text-xl font-semibold text-gray-500 dark:text-gray-400"
                >
                    暂无收藏商品
                </div>
            </CardContent>
        </Card>
    </div>
</template>

<script setup>
import {
    Card,
    CardTitle,
    CardHeader,
    CardContent,
    CardDescription,
} from "@/components/ui/card";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";

import api from "@/utils/api";
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { success } from "@/utils/message";

//路由管理
const router = useRouter();
//页面数据
const products = ref([]);
const imgList = ref([]);
onMounted(() => {
    getCollection();
});
const getCollection = async () => {
    await api({
        url: "/user/product/allCollections",
        method: "GET",
    }).then((res) => {
        if (res.data != null) {
            products.value = res.data;
            products.value.map((item) => {
                imgList.value.push(item.image);
            });
        } else {
            products.value = [];
        }
    });
};

const detail = async (id) => {
    router.push({
        path: "/detail",
        query: {
            productId: id,
        },
    });
};

const cancelCollection = (id) => {
    api({
        url: "/user/product/cancelCollect",
        method: "POST",
        params: {
            id: id,
        },
    }).then((res) => {
        if (res.code === 1) {
            success("取消收藏成功");
            getCollection();
        }
    });
};
</script>
