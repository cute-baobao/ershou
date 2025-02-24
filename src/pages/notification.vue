<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Card, CardContent } from "../components/ui/card";
import { Icon } from "@iconify/vue";

import api from "@/utils/api.js";
import formatDate from "@/utils/timeUtils.js";
import { useRouter } from "vue-router";

interface Notification {
    id: number;
    title: string;
    content: string;
    createTime: string;
    type: string;
    userId: number;
    orderId: number;
    readed: boolean;
}

const router = useRouter();
const page = ref(1);
const pageSize = ref(5);
const notifications = ref<{ total: number; records: Notification[] }>({
    total: 0,
    records: [],
});

onMounted(() => {
    getNotice();
    readNotice();
});

const getNotice = () => {
    api.post("/user/notice/page", {
        page: page.value,
        pageSize: pageSize.value,
    }).then((res: any) => {
        notifications.value.total = res.data.total;
        notifications.value.records = res.data.records as Notification[];
    });
};

const typeNode = (str: string) => {
    switch (str) {
        case "商品下单通知":
            return 1;
        case "商品发货通知":
            return 2;
        case "订单取消通知":
            return 3;
        default:
            return 0;
    }
};

const handleCurrentChange = (val: number) => {
    page.value = val;
    getNotice();
};

const readNotice = () => {
    api.put("/user/notice/readed");
};

const routerToOrder = (id: number,type:number) => {
    router.push({
        path: "/orderDetail",
        query: {
            buyOrSell: type === 2 ? 1 : 2,
            id: id,
        },
    });
};
</script>

<template>
    <div class="container mx-auto px-4 py-8">
        <h1
            class="text-2xl font-bold mb-6 flex items-center gap-2 dark:text-white"
        >
            <Icon icon="mdi:bell-outline" class="w-6 h-6" />
            系统通知
        </h1>

        <div class="h-[80vh]">
            <div class="space-y-4">
                <Card
                    v-for="notice in notifications.records"
                    :key="notice.id"
                    @click="routerToOrder(notice.orderId,typeNode(notice.type))"
                    class="hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors cursor-pointer"
                >
                    <CardContent class="p-6">
                        <div class="flex items-start gap-4">
                            <div class="shrink-0">
                                <Icon
                                    :icon="
                                        typeNode(notice.type) === 1
                                            ? 'mdi:cart-check'
                                            : typeNode(notice.type) === 2
                                            ? 'mdi:truck-delivery'
                                            : typeNode(notice.type) === 3
                                            ? 'mdi:cart-remove'
                                            : 'mdi:information-outline'
                                    "
                                    class="w-5 h-5 text-blue-500"
                                />
                            </div>
                            <div class="flex-1 space-y-2">
                                <h3 class="font-semibold dark:text-white">
                                    {{ notice.title }}
                                </h3>
                                <p
                                    class="text-gray-600 dark:text-gray-300 text-sm"
                                >
                                    {{ notice.content }}
                                </p>
                                <div class="flex justify-between items-center">
                                    <time class="text-xs text-gray-500">{{
                                        formatDate(notice.createTime)
                                    }}</time>
                                    <!-- <a v-if="notice.link" 
                    :href="notice.link"
                    class="text-sm text-blue-500 hover:text-blue-600 flex items-center gap-1"
                  >
                    查看详情
                    <Icon icon="mdi:chevron-right" class="w-4 h-4" />
                  </a> -->
                                </div>
                            </div>
                        </div>
                    </CardContent>
                </Card>
                <div class="flex justify-center mt-4">
                    <el-pagination
                        v-model:current-page="page"
                        v-model:page-size="pageSize"
                        hide-on-single-page
                        :background="true"
                        layout=" prev, pager, next"
                        :total="notifications.total"
                        @current-change="handleCurrentChange"
                        class="bg-white dark:bg-slate-800 px-4 py-2 rounded-full shadow-sm"
                    />
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.container {
    max-width: 768px;
}
</style>
