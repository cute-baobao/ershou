<script setup>
import Post from '@/components/post/Post.vue'
import PublishPost from '@/components/post/PublishPost.vue'

import api from "@/utils/api.js"
import { computed, onMounted, ref } from 'vue';
import { useUser } from '@/utils/pinia'
import { Icon } from '@iconify/vue/dist/iconify.js';
import { Redo } from 'lucide-vue-next';

const noMore = computed(() => record.value.records.length === record.value.total)
const isloading = ref(false)
const user = useUser().getUser()
const page = ref(1)
const pageSize = ref(2)
const record = ref({
  records: [],
  total: 0
})

onMounted(async () => {
  await getPost()
  console.log("我是同步的")
})

const getPost = async () => {
  isloading.value = true
  await api.get('/user/post/page', {
    params: {
      page: page.value,
      pageSize: pageSize.value,
      loginUserId:user.id,
    }
  }).then((res) => {
    record.value.total = res.data.total
    record.value.records.push(...res.data.records)
    console.log(record.value)
  }).finally(() => {
    isloading.value = false
  })
}

const loadMore = () => {
  page.value+= 1
  getPost()
}

</script>

<template>
  <div class="min-h-[100svh] bg-slate-200 dark:bg-slate-900 relative py-6">
    <div class="max-w-2xl space-y-6 mx-auto px-4">
      <PublishPost @addPost="getPost" />
      <div class="space-y-6">
        <Post v-for="i in record.records" :post="i" :key="i" />
      </div>
      <div class="flex items-center justify-center">
          <span v-if="noMore" class="text-main font-mono">没有更多了</span>
          <span @click="loadMore" v-else-if="!isloading" class="hover:underline cursor-pointer active:text-main text-xl font-mono">加载更多</span>
          <span v-else class="text-main font-mono flex items-center">
            <Icon icon="line-md:loading-loop" class="animate-spin" />
            加载中...
          </span>
      </div>
    </div>
  </div>
</template>