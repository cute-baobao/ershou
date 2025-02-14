<template>
  <div
    class="min-h-screen bg-gradient-to-br from-red-50 to-orange-50 dark:from-red-950 dark:to-orange-950 flex items-center justify-center p-4 sm:p-6 lg:p-8 relative overflow-hidden">
    <Card class="w-full max-w-md bg-white dark:bg-slate-800 shadow-2xl">
      <CardHeader>
        <CardTitle class="text-2xl sm:text-3xl font-bold text-center text-red-600 dark:text-red-400">
          审核未通过
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div class="text-center mb-6">
          <AlertCircle class="w-24 h-24 mx-auto text-red-500 dark:text-red-400" />
        </div>
        <p class="text-gray-700 dark:text-gray-300 text-center mb-6">
          很抱歉，您的闲置宝贝未能通过我们的审核。请检查发布的信息并确保符合我们的规定要求。
        </p>
        <p class="text-gray-700 dark:text-gray-300 text-center mb-6">
          拒绝原因： {{ remark }}
        </p>
      </CardContent>
      <CardFooter class="flex justify-center">
        <Button @click="goToHome"
          class="w-full bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700 text-white text-lg py-3 rounded-lg transition-colors duration-300">
          返回首页
        </Button>
      </CardFooter>
    </Card>
  </div>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { AlertCircle } from 'lucide-vue-next'
import { onMounted, ref } from 'vue';

const router = useRouter()
const route = useRoute()
const remark = ref(null)
onMounted(() => {
  window.scrollTo(0, 0)
  remark.value = route.query.remark
})
const goToHome = () => {
  router.push('/index')
}
</script>