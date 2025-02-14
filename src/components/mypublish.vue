<template>
    <div>
        <Card class="max-w-5xl mx-auto bg-white dark:bg-slate-900">
            <CardHeader class="space-y-2">
                <CardTitle class="flex justify-between items-center">
                    <span
                        class="text-xl sm:text-2xl font-bold text-gray-800 dark:text-gray-200"
                        >我发布的商品</span
                    >
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div
                    class="space-y-4 overflow-y-auto scroll-smooth max-h-[40svh]"
                    v-if="products.length > 0"
                >
                    <div
                        v-for="(item, index) in products"
                        :key="item.productId"
                        class="flex items-center bg-gray-50 dark:bg-slate-800 border relative border-gray-200 dark:border-slate-700 rounded-lg p-3 shadow-sm hover:shadow-md transition-all duration-300"
                        :class="{
                            'bg-gray-100 dark:bg-slate-700':
                                item.isSaled === 1 ||
                                item.statusMessage !== '审核通过',
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
                            @click="
                                item.statusMessage === '审核不通过'
                                    ? remark(item.remark)
                                    : detail(item.productId)
                            "
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
                            <DropdownMenu>
                                <DropdownMenuTrigger asChild>
                                    <Button
                                        variant="outline"
                                        size="sm"
                                        class="text-xs px-2 bg-white dark:bg-slate-700 text-gray-800 dark:text-gray-200 border-gray-300 dark:border-slate-600"
                                    >
                                        更多操作
                                    </Button>
                                </DropdownMenuTrigger>
                                <DropdownMenuContent>
                                    <DropdownMenuGroup>
                                        <DropdownMenuItem
                                            v-if="
                                                item.statusMessage !==
                                                '审核不通过'
                                            "
                                            @click="detail(item.productId)"
                                        >
                                            详情
                                        </DropdownMenuItem>
                                        <DropdownMenuItem
                                            :disabled="item.isSaled == 1"
                                            @click="update(item.productId)"
                                        >
                                            修改商品
                                        </DropdownMenuItem>
                                        <DropdownMenuItem
                                            v-if="
                                                item.statusMessage ===
                                                    '审核不通过' ||
                                                item.statusMessage ===
                                                    '发布成功'
                                            "
                                            :disabled="item.isSaled == 1"
                                            @click="del(item.productId)"
                                        >
                                            删除商品
                                        </DropdownMenuItem>
                                        <DropdownMenuItem
                                            v-if="
                                                item.statusMessage ===
                                                '审核不通过'
                                            "
                                            @click="remark(item.remark)"
                                        >
                                            查看审核结果
                                        </DropdownMenuItem>
                                        <DropdownMenuItem
                                            v-if="
                                                item.statusMessage ===
                                                '审核通过'
                                            "
                                            :disabled="item.isSaled == 1"
                                            @click="cancel(item.productId)"
                                        >
                                            下架商品
                                        </DropdownMenuItem>
                                    </DropdownMenuGroup>
                                </DropdownMenuContent>
                            </DropdownMenu>
                        </div>
                        <div
                            v-if="item.isSaled === 1"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-orange-500 text-white text-xs font-bold rounded-br-lg shadow-md"
                        >
                            已售出
                        </div>
                        <div
                            v-else-if="item.statusMessage === '审核不通过'"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-red-500 text-white text-xs font-bold rounded-br-lg shadow-md"
                        >
                            审核未通过
                        </div>
                        <div
                            v-else-if="item.statusMessage === '发布成功'"
                            class="absolute top-0 left-0 m-1 px-2 py-1 bg-yellow-400 text-gray-800 text-xs font-bold rounded-br-lg shadow-md"
                        >
                            待审核
                        </div>
                    </div>
                </div>
                <div
                    v-else
                    class="flex justify-center items-center h-40 text-xl font-semibold text-gray-500 dark:text-gray-400"
                >
                    暂无商品
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
    DropdownMenuGroup,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";

import api from "@/utils/api";
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import { success } from "@/utils/message";
import { useUser } from "@/utils/pinia";

//用户信息
const user = useUser();
//路由管理
const router = useRouter();
//页面数据
const products = ref([]);
const imgList = ref([]);
onMounted(() => {
    getProduct();
});
const getProduct = async () => {
    await api({
        url: "/user/product/allPublished",
        method: "GET",
        params: {
            userId: user.getUser().id,
        },
    }).then((res) => {
        if (res.code === 1 && res.data != null) {
            products.value = res.data;
            products.value.map((item) => {
                imgList.value.push(item.image);
            });
        } else {
            products.value = [];
        }
        //console.log(products.value)
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

const update = async (id) => {
    router.push({
        path: "/update",
        query: {
            id: id,
        },
    });
};

const cancel = async (id) => {
    await api({
        url: "/user/product/delete",
        method: "PUT",
        params: {
            id: id,
        },
    }).then((res) => {
        if (res.code === 1) {
            success("下架商品成功");
            getProduct();
        }
    });
};

const remark = (remark) => {
    router.push({
        path: "/fail",
        query: {
            remark: remark,
        },
    });
};

const del = (id) => {
    api({
        url: "/user/product/delete",
        method: "DELETE",
        params: {
            id: id,
        },
    }).then((res) => {
        success("删除商品成功");
        getProduct();
    });
};
</script>
