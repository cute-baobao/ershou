<template>
  <div class="min-h-[90svh] bg-gray-100 dark:bg-slate-900 flex items-center justify-center px-4">
    <div class="max-w-md w-full text-center">
      <div class="mb-8">
        <FileQuestion class="w-24 h-24 mx-auto text-gray-400 dark:text-gray-600" />
      </div>
      <h1 class="text-6xl font-bold text-gray-800 dark:text-gray-200 mb-4">404</h1>
      <p class="text-xl text-gray-600 dark:text-gray-400 mb-8">
        哎呀！看来您迷路了。<br>
        您访问的页面不存在。
      </p>
      <Button @click="goToHome" class="bg-blue-500 hover:bg-blue-600 text-white">
        返回首页
      </Button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { Button } from '@/components/ui/button'
import { FileQuestion } from 'lucide-vue-next'

const router = useRouter()

/**
 * @param {string} path
 */
const goToHome = () => {
  router.push('/index')
}
</script>