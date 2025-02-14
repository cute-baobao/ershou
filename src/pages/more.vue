<template>
    <div
        ref="father"
        id="container"
        class="min-h-screen bg-slate-100 dark:bg-slate-950"
    >
        <!-- <Header /> -->
        <main
            class="container mx-auto px-[5%] py-1 sm:px-[5%] md:px-[5%] lg:px-[5%]"
        >
            <!-- //头部 -->
            <section class="text-center mt-4 mb-4">
                <div class="flex justify-center">
                    <div class="relative w-full max-w-xl">
                        <input
                            type="text"
                            v-model="title"
                            placeholder="搜索闲置宝贝..."
                            @keyup.enter="search"
                            class="w-full px-4 py-2 rounded-full border-2 border-green-300 focus:outline-none focus:border-green-500 text-black"
                        />
                        <button
                            class="absolute right-2 top-1/2 transform -translate-y-1/2 bg-green-500 text-white p-2 rounded-full hover:bg-green-600 transition duration-300"
                            @click="search()"
                        >
                            <Icon
                                icon="material-symbols:search"
                                width="24"
                                height="24"
                            />
                        </button>
                    </div>
                </div>
            </section>
            <section
                class="flex flex-col gap-2 border border-white dark:border-slate-800 border-solid bg-slate-50 dark:bg-slate-900 rounded-lg p-2 mb-4 shadow-lg"
            >
                <div class="grid grid-cols-4 gap-2 items-center relative">
                    <selectItem v-model="category" :holder="'分类'">
                        <template #item>
                            <SelectItem value="-1">默认</SelectItem>
                            <SelectItem
                                v-for="item in categoryList"
                                :key="item.id"
                                :value="String(item.id)"
                            >
                                {{ item.name }}
                            </SelectItem>
                        </template>
                    </selectItem>
                    <selectItem v-model="price" :holder="'价格'">
                        <template #item>
                            <SelectItem value="-1">默认</SelectItem>
                            <SelectItem value="1">价格从高到低</SelectItem>
                            <SelectItem value="2">价格从低到高</SelectItem>
                        </template>
                    </selectItem>
                    <selectItem v-model="pageSize" holder="商品数">
                        <template #item>
                            <SelectItem value="8">8</SelectItem>
                            <SelectItem value="10">10</SelectItem>
                            <SelectItem value="15">15</SelectItem>
                        </template>
                    </selectItem>
                    <div></div>
                </div>
                <div
                    v-if="dataIsLoading"
                    class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 sm:gap-4 md:gap-5"
                >
                    <div v-for="n in 10" :key="n" class="space-y-3">
                        <Skeleton class="h-44 w-full" />
                        <Skeleton class="h-6 w-3/4" />
                        <Skeleton class="h-6 w-1/2" />
                    </div>
                </div>
                <div
                    v-if="products.total > 0"
                    class="w-full flex justify-center"
                >
                    <div
                        class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-1 sm:gap-2 md:gap-3 lg:gap-4"
                    >
                        <productCard
                            v-for="item in products.records"
                            :product="item"
                            :key="item.productId"
                        />
                    </div>
                </div>
                <div
                    v-if="products.total === 0 && dataIsLoading === false"
                    class="flex justify-center p-2 text-5xl font-semibold text-main h-[60svh] items-center"
                >
                    暂无闲置宝贝
                </div>
            </section>
            <div class="mt-6 flex justify-center">
                <el-pagination
                    class="bg-white dark:bg-slate-800 rounded-full px-2 py-1 shadow-sm"
                    background
                    hide-on-single-page
                    layout="prev, pager, next"
                    :total="products.total"
                    :current_page="currentPage"
                    :page-size="Number(pageSize)"
                    @current-change="currentPageChange"
                />
            </div>
        </main>
        <footerComponent />
    </div>
</template>

<script setup>
import Skeleton from "@/components/ui/skeleton/Skeleton.vue";
import { Label } from "@/components/ui/label";
import { ChevronDown } from "lucide-vue-next";
import { Button } from "@/components/ui/button";
import { SelectItem, SelectLabel } from "@/components/ui/select";
import { Icon } from "@iconify/vue/dist/iconify.js";

import productCard from "@/components/productCard.vue";
import footerComponent from "@/components/footerComponent.vue";
import selectItem from "@/components/selectItem.vue";

import { onMounted, onUnmounted, ref, watch } from "vue";
import api from "@/utils/api.js";
import { useRoute } from "vue-router";

//路由
const route = useRoute();

//页面数据
const father = ref(null);
const currentPage = ref(1);
const pageSize = ref("15");
const categoryList = ref([]);
const category = ref(null);
const title = ref("");
const price = ref(null);
const products = ref({
    total: 0,
    records: [],
});
const dataIsLoading = ref(false);

onMounted(async () => {
    if (route.query.category) {
        category.value = route.query.category;
    }
    if (route.query.title) {
        title.value = route.query.title;
    }
    window.scrollTo(0, 0);
    await search();
    await getCategory();
});

const loadData = async () => {
    dataIsLoading.value = true;
    await api({
        method: "GET",
        url: "/user/product/page",
        params: {
            page: currentPage.value,
            pageSize: Number(pageSize.value),
            title: title.value === "" ? null : title.value,
            categoryId:
                category.value === "-1" || category.value === null
                    ? null
                    : Number(category.value),
            priceOrderCode:
                price.value === "-1" || price.value === null
                    ? null
                    : Number(price.value),
        },
    })
        .then((res) => {
            products.value.total = res.data.total;
            products.value.records = res.data.records;
            // 滑动到顶部
            window.scrollTo({
                top: 0,
                behavior: "smooth", // 平滑滚动
            });
        })
        .finally(() => {
            dataIsLoading.value = false;
        });
};

const getCategory = async () => {
    await api({
        url: "/admin/category/list",
        method: "GET",
    }).then((res) => {
        categoryList.value = res.data;
    });
};

const currentPageChange = async (val) => {
    currentPage.value = val;
    await loadData();
};

const search = async () => {
    currentPage.value = 1;
    products.value.records = [];
    await loadData();
};

watch(
    () => category.value,
    async () => {
        await search();
    }
);

watch(
    () => price.value,
    async () => {
        await search();
    }
);
watch(
    () => pageSize.value,
    async () => {
        await search();
    }
);
</script>
<style scoped lang="scss">
:deep(.el-pagination.is-background .el-pager li:not(.is-disabled).is-active) {
    background-color: #34d399 !important; //修改默认的背景色
}
</style>
