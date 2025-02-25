<template>
    <div
        class="min-h-svh w-full bg-gradient-to-br from-slate-200 to-slate-200 dark:from-slate-900 dark:via-slate-800 dark:to-green-900 p-6 relative overflow-hidden"
    >
        <div class="relative z-10 max-w-7xl mx-auto">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- 左侧列 -->
                <div class="space-y-6 flex flex-col">
                    <!-- 个人信息卡片 -->
                    <Card class="bg-white dark:bg-slate-900 shadow-md">
                        <CardHeader>
                            <CardTitle>个人信息</CardTitle>
                        </CardHeader>
                        <CardContent class="flex items-center space-x-4">
                            <Avatar class="w-16 h-16">
                                <AvatarImage :src="userInfo.avatar" />
                                <AvatarFallback>{{
                                    userInfo.username.charAt(0)
                                }}</AvatarFallback>
                            </Avatar>
                            <div>
                                <h3 class="text-lg font-semibold">
                                    {{ userInfo.username }}
                                </h3>
                                <p
                                    class="text-sm text-gray-500 dark:text-gray-400"
                                >
                                    ID: {{ user.getUser().id }}
                                </p>
                            </div>
                        </CardContent>
                        <CardFooter class="flex items-center gap-2">
                            <userUpdate />
                            <addressNav />
                            <passwordUpdate />
                        </CardFooter>
                    </Card>

                    <!-- 四个数据卡片 -->
                    <div class="grid grid-cols-2 gap-4">
                        <Card class="bg-white dark:bg-slate-900 shadow-md">
                            <CardHeader
                                class="flex flex-row items-center justify-between pb-2"
                            >
                                <CardTitle class="text-sm font-medium"
                                    >碳积分</CardTitle
                                >
                                <Award
                                    class="h-4 w-4 text-green-600 dark:text-green-400"
                                />
                            </CardHeader>
                            <CardContent>
                                <div class="text-2xl font-bold">
                                    {{ userPoints }}
                                </div>
                                <p
                                    class="text-xs text-green-600 dark:text-green-400"
                                >
                                    可通过交易物品获得积分奖励
                                </p>
                            </CardContent>
                        </Card>
                        <Card
                            @click="router.push('/orderCenter')"
                            class="cursor-pointer bg-white dark:bg-slate-900 shadow-md hover:bg-gray-100 hover:dark:bg-gray-700 transition-colors duration-200"
                        >
                            <CardHeader
                                class="flex flex-row items-center justify-between pb-2"
                            >
                                <CardTitle class="text-sm font-medium"
                                    >我买到的</CardTitle
                                >
                                <Award
                                    class="h-4 w-4 text-green-600 dark:text-green-400"
                                />
                            </CardHeader>
                            <CardContent>
                                <div class="text-2xl font-bold">
                                    {{ buy }}件
                                </div>
                                <p
                                    class="text-xs text-green-600 dark:text-green-400"
                                >
                                    点击查看详情
                                </p>
                            </CardContent>
                        </Card>
                        <Card
                            @click="router.push('/sellerOrder')"
                            class="bg-white dark:bg-slate-900 shadow-md cursor-pointer hover:bg-gray-100 hover:dark:bg-gray-700 transition-colors duration-200"
                        >
                            <CardHeader
                                class="flex flex-row items-center justify-between pb-2"
                            >
                                <CardTitle class="text-sm font-medium"
                                    >我卖出的</CardTitle
                                >
                                <Award
                                    class="h-4 w-4 text-green-600 dark:text-green-400"
                                />
                            </CardHeader>
                            <CardContent>
                                <div class="text-2xl font-bold">
                                    {{ sell }}件
                                </div>
                                <p
                                    class="text-xs text-green-600 dark:text-green-400"
                                >
                                    点击查看详情
                                </p>
                            </CardContent>
                        </Card>
                        <Card
                            @click="router.push('/pointStore')"
                            class="bg-white dark:bg-slate-900 shadow-md cursor-pointer hover:bg-gray-100 hover:dark:bg-gray-700 transition-colors duration-200"
                        >
                            <CardHeader
                                class="flex flex-row items-center justify-between pb-2"
                            >
                                <CardTitle class="text-sm font-medium"
                                    >积分商城</CardTitle
                                >
                                <Award
                                    class="h-4 w-4 text-green-600 dark:text-green-400"
                                />
                            </CardHeader>
                            <CardContent>
                                <p
                                    class="text-xs text-green-600 dark:text-green-400"
                                >
                                    点击查看积分商品
                                </p>
                            </CardContent>
                        </Card>
                    </div>

                    <!-- 环保小贴士 -->
                    <Card class="bg-white dark:bg-slate-900 shadow-md flex-1">
    <CardHeader>
        <CardTitle>环保俳句</CardTitle>
    </CardHeader>
    <CardContent>
        <div class="flex items-center justify-center gap-2">
            <div class="text-center space-y-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800">
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">青空映碧水</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">单车碾碎尾烟尘</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">云影落归人</p>
            </div>
            
            <div class="text-center space-y-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800">
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">旧书叠成山</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">墨香裹住废纸团</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">新芽破页间</p>
            </div>
            
            <div class="text-center space-y-2 p-4 rounded-lg bg-slate-50 dark:bg-slate-800">
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">冰箱空半腹</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">省电犹如护星图</p>
                <p class="text-lg font-medium text-gray-800 dark:text-gray-200">夜灯照简朴</p>
            </div>
        </div>
    </CardContent>
</Card>

                </div>

                <!-- 右侧列 -->
                <div class="space-y-6">
                    <mypublish
                        class="bg-white dark:bg-slate-900 shadow-md rounded-lg"
                    />
                    <collection
                        class="bg-white dark:bg-slate-900 shadow-md rounded-lg"
                    />
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { Button } from "@/components/ui/button";
import {
    Card,
    CardTitle,
    CardHeader,
    CardContent,
    CardFooter,
} from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Award } from "lucide-vue-next";
import userUpdate from "@/components/userUpdate.vue";
import passwordUpdate from "@/components/passwordUpdate.vue";
import addressNav from "@/components/addressNav.vue";
import collection from "@/components/collection.vue";
import mypublish from "@/components/mypublish.vue";
import { useUser } from "@/utils/pinia";
import api from "@/utils/api";

const router = useRouter();
const user = useUser();

const userPoints = ref(0);
const buy = ref(0);
const sell = ref(0);
const userInfo = ref({
    username: "",
    avatar: "",
});

const dailyTip = ref(
    "减少使用一次性塑料制品，选择可重复使用的替代品，为地球减负。"
);

onMounted(() => {
    userInfo.value = { ...user.getUser() };
    getPoint();
    getAllOrder(1, buy);
    getAllOrder(2, sell);
});

const getPoint = () => {
    api({
        url: "/user/user/getPoint",
        method: "GET",
        params: {
            id: user.getUser().id,
        },
    }).then((res) => {
        userPoints.value = res.data;
    });
};

const getAllOrder = async (buyOrSell, value) => {
    let data = {
        page: 1,
        pageSize: 10,
        status: 4,
        title: null,
        buyOrSell: buyOrSell,
        productType: 1,
    };
    await api({
        url: "/user/order/page",
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        data: data,
    }).then((res) => {
        if (res.code === 1) {
            value.value = res.data.total;
        }
    });
};
</script>

<style scoped>
/* 如果需要额外的样式，可以在这里添加 */
</style>
