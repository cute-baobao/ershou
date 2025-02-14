<template>
  <div
    class="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 dark:from-green-900 dark:to-blue-900 flex items-center justify-center p-4 sm:p-6 lg:p-8 relative overflow-hidden">
    <div
      class="max-w-md w-full bg-white dark:bg-slate-800 rounded-2xl shadow-2xl p-8 sm:p-10 relative z-10 transition-all duration-300 ease-in-out transform hover:scale-105">
      <div class="text-center">
        <div class="mb-6">
          <CheckCircle class="w-24 h-24 sm:w-28 sm:h-28 mx-auto text-green-500 dark:text-green-400" />
        </div>
        <h1 class="text-3xl sm:text-4xl font-bold text-gray-800 dark:text-white mb-6">{{ msg }}</h1>
        <div class="space-y-4">
          <Button @click="goToHome"
            class="w-full bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700 text-white text-lg py-3 rounded-lg transition-colors duration-300">
            返回首页
          </Button>
          <Button @click="viewProduct" v-if="msg === '发布成功'" variant="outline"
            class="w-full text-lg py-3 rounded-lg border-2 border-blue-500 text-blue-500 hover:bg-blue-50 dark:border-blue-400 dark:text-blue-400 dark:hover:bg-blue-900 transition-colors duration-300">
            查看宝贝
          </Button>
          <Button @click="viewProduct" v-else-if="msg === '修改成功'" variant="outline"
            class="w-full text-lg py-3 rounded-lg border-2 border-blue-500 text-blue-500 hover:bg-blue-50 dark:border-blue-400 dark:text-blue-400 dark:hover:bg-blue-900 transition-colors duration-300">
            查看宝贝
          </Button>
          <Button v-else @click="viewOrder" variant="outline"
            class="w-full text-lg py-3 rounded-lg border-2 border-blue-500 text-blue-500 hover:bg-blue-50 dark:border-blue-400 dark:text-blue-400 dark:hover:bg-blue-900 transition-colors duration-300">
            查看订单
          </Button>
        </div>
      </div>
    </div>
    <div
      class="absolute inset-0 bg-gradient-to-br from-green-200 to-blue-200 dark:from-green-800 dark:to-blue-800 opacity-50 z-0">
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { Button } from '@/components/ui/button'
import { CheckCircle } from 'lucide-vue-next'
import { useRouter, useRoute } from 'vue-router';

const route = useRoute()
const router = useRouter()

const msg = ref("")
onMounted(() => {
  if (route.query.msg) {
    msg.value = route.query.msg
  }
})
const goToHome = () => {
  router.push('/index')
}

const viewOrder = () => {
  if (msg.value === "兑换成功")
    router.push("/pointOrderCenter")
  else
    router.push("/orderCenter")
}

const viewProduct = () => {
  router.push("/personalCenter")
}

</script>
