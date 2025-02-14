<template>
  <div id="container"
    class="min-h-svh bg-gradient-to-br from-slate-100 to-slate-100 dark:from-slate-950 dark:to-slate-900 relative overflow-hidden">

    <main class="container mx-auto px-[5%] py-6 relative z-10">
      <!-- 头部 -->
      <section class="text-center mb-2">
        <!-- <h1 class="text-2xl font-bold mb-4 text-gray-800 dark:text-gray-100"></h1> -->
        <h2 class="text-5xl font-bold mb-6 text-main">共建绿色低碳生活</h2>
        <p class="text-xl text-gray-600 dark:text-gray-300 mb-10">通过二手交易，我们共同为环保事业贡献力量，创造可持续的未来</p>
        <div class="flex justify-center mb-6">
          <div class="relative w-full max-w-xl">
            <input v-model="title" type="text" placeholder="搜索闲置宝贝..." @keyup.enter="search"
              class="w-full px-5 py-2 rounded-full border-2 border-green-300 focus:outline-none focus:border-green-500 text-gray-800 dark:text-gray-200 dark:bg-slate-800 dark:border-green-700 dark:focus:border-green-500 transition duration-300 shadow-sm" />
            <button @click="search"
              class="absolute right-2 top-1/2 transform -translate-y-1/2 bg-green-500 text-white p-2 rounded-full hover:bg-green-600 transition duration-300 focus:outline-none focus:ring-2 focus:ring-green-400 focus:ring-opacity-50">
              <Icon icon="material-symbols:search" width="24" height="24" />
            </button>
          </div>
        </div>
      </section>

      <!-- 分类和理由的组合部分 -->
      <section class="mb-10 flex flex-wrap -mx-2">
        <!-- 分类 -->
        <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
          <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-100">热门分类</h2>
          <div v-if="categoryLoading" class="grid grid-cols-2 gap-3">
            <div v-for="i in 4" :key="i" class="bg-white dark:bg-slate-800 p-3 rounded-lg shadow-md">
              <Skeleton class="h-10 w-10 mx-auto mb-2" />
              <Skeleton class="h-4 w-3/4 mx-auto" />
            </div>
          </div>
          <div v-else class="grid grid-cols-2 gap-3">
            <div v-for="category in categories" :key="category.name" @click="more(category.id)"
              class="bg-white dark:bg-slate-800 cursor-pointer p-3 rounded-lg shadow-md hover:shadow-lg transition duration-300 text-center border border-green-100 dark:border-green-900 hover:border-green-300 dark:hover:border-green-700">
              <ShoppingBag class="h-10 w-10 mx-auto mb-2 text-green-600 dark:text-green-400" />
              <h3 class="text-sm font-semibold text-gray-800 dark:text-gray-200">{{ category.name }}</h3>
            </div>
          </div>
        </div>

        <!-- 理由 -->
        <div class="w-full md:w-1/2 px-2">
          <h2 class="text-2xl font-semibold mb-3 text-gray-800 dark:text-gray-100">为什么选择小碳？</h2>
          <div class="bg-white dark:bg-slate-800 rounded-lg shadow-md p-4">
            <div v-for="reason in reasons" :key="reason.title" class="flex items-center mb-3 last:mb-0">
              <component :is="reason.icon" class="h-8 w-8 text-green-600 dark:text-green-400 mr-3 flex-shrink-0" />
              <div>
                <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-200">{{ reason.title }}</h3>
                <p class="text-sm text-gray-600 dark:text-gray-300">{{ reason.description }}</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 猜你喜欢 -->
      <section>
        <h2 class="text-2xl font-semibold mb-4 text-gray-800 dark:text-gray-100">精选宝贝</h2>
        <div class="w-full">
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 sm:gap-4 md:gap-5">
            <productCard v-for="item in products.records" :product="item" :key="item" />
          </div>
          <!-- 加载动画 -->
          <div v-if="dataIsLoading"
            class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 sm:gap-4 md:gap-5 mt-10">
            <div v-for="n in 5" :key="n" class="space-y-4">
              <Skeleton class="h-40 w-full" />
              <Skeleton class="h-4 w-3/4" />
              <Skeleton class="h-4 w-1/2" />
            </div>
          </div>
        </div>
        <!-- <div v-if="dataIsLoading" class="flex justify-center p-2">
          <Skeleton class="w-[50px] h-[50px] rounded-full bg-main" />
        </div> -->

        <div class="flex justify-center mt-2">
          <span @click="router.push('/more')" class=" text-main cursor-pointer mt-3 text-sm hover:underline flex items-center hover:text-base hover:font-semibold font-bold">查看更多宝贝</span>
        </div>
      </section>
    </main>
    <footerComponent />
  </div>
</template>

<script setup>

import { ShoppingBag, Recycle, TrendingUp, Heart } from 'lucide-vue-next'
import productCard from '@/components/productCard.vue';
import footerComponent from '@/components/footerComponent.vue';
import Skeleton from '@/components/ui/skeleton/Skeleton.vue';
import { Button } from "@/components/ui/button"

import api from '@/utils/api.js';
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router';
import { info } from "@/utils/message"
import { Icon } from '@iconify/vue/dist/iconify.js';
//页面加载
const dataIsLoading = ref(false)

//路由管理
const router = useRouter()

//页面数据
const title = ref('')
const categories = ref([])
const currentPage = ref(1)
const categoryLoading = ref(false)
const reasons = ref([
  { title: '环保再利用', description: '减少浪费，为地球减轻负担', icon: Recycle },
  { title: '好礼兑换', description: '交易可获得积分，换取精美产品', icon: TrendingUp },
  { title: '独特魅力', description: '发现独一无二的珍品', icon: Heart },
])
const products = ref({
  total: 0,
  records: []
})

onMounted(async () => {
  loadData()
  getCategory()
})

const loadData = async () => {
  dataIsLoading.value = true
  // if (currentPage.value * 5 >= products.value.total && currentPage.value != 1) {
  //   info("暂时没有更多宝贝了")
  //   window.removeEventListener('scroll', scrollHandler)
  // }
  await api({
    method: "GET",
    url: '/user/product/page',
    params: {
      page: currentPage.value,
      pageSize: 10
    }
  }).then(res => {
    products.value.total = res.data.total
    products.value.records.push(...res.data.records)
    //console.log(products.value)
    currentPage.value++
  }).finally(() => {
    dataIsLoading.value = false
  })
}

// 滚动事件监听 暂时不用了
// const scrollHandler = () => {
//   if (dataIsLoading.value === true) {
//     return
//   }
//   let clientHeight = document.documentElement.clientHeight; //浏览器高度
//   let scrollHeight = document.body.scrollHeight;
//   let scrollTop = document.documentElement.scrollTop;
//   if (scrollTop + clientHeight >= scrollHeight - 200) {
//     loadData()
//   }
// }

const getCategory = async () => {
  categoryLoading.value = true
  await api({
    url: '/user/category/top/4',
    method: 'GET'
  }).then(res => {
    categories.value = res.data
  }).finally(() => {
    categoryLoading.value = false
  })
}

const more = (id) => {
  router.push({
    path: '/more',
    query: {
      category: id
    }
  })
}

const search = () => {
  router.push({
    path: '/more',
    query: {
      title: title.value
    }
  })
}

</script>