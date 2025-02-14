<template>
  <header class="bg-gradient-to-r from-green-300 to-green-400 dark:from-slate-800 dark:to-slate-800 text-gray-800 dark:text-white shadow-lg transition-colors duration-300">
    <div class="container mx-auto px-4 py-3">
      <div class="flex justify-between items-center">
        <router-link to="/index" class="flex items-center space-x-2 hover:opacity-80 transition-opacity duration-200">
          <img src="@/assets/yezi.svg" class="h-10 w-7" alt="Logo" />
          <span class="text-xl font-bold">小碳</span>
        </router-link>
        <nav class="hidden md:flex space-x-6">
          <router-link 
            v-for="item in navItems" 
            :key="item.path" 
            :to="item.path" 
            class="relative py-2 px-1 hover:text-green-600 dark:hover:text-green-300 transition-colors duration-200 ease-in-out"
            :class="{ 'text-green-600 dark:text-green-300 font-semibold': isActive(item.path) }"
          >
            {{ item.name }}
            <span 
              v-if="isActive(item.path)" 
              class="absolute bottom-0 left-0 w-full h-0.5 bg-green-600 dark:bg-green-300 rounded-full"
            ></span>
          </router-link>
          <a 
            href="https://cute-baobao.github.io" 
            target="_blank" 
            class="py-2 px-1 hover:text-green-600 dark:hover:text-green-300 transition-colors duration-200 ease-in-out"
          >
            关于我们
          </a>
        </nav>
        <div class="flex items-center space-x-4">
          <userNav/>
          <changeMode/>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import userNav from './userNav.vue';
import changeMode from './changeMode.vue';

const route = useRoute();

const navItems = ref([
  { name: '首页', path: '/index' },
  { name: '分类', path: '/more' },
  { name: '订单', path: '/orderCenter' },
  { name: '小碳论坛', path: '/posts' },
  { name: '卖家中心', path: '/sellerOrder' },
  { name: '积分商城', path: '/pointStore' },
  { name: '碳足迹计算', path: '/carbonComputed' },
]);

const isActive = computed(() => (path) => {
  return route.path === path;
});
</script>