<script setup>
import Post from '@/components/post/Post.vue'
import PublishPost from '@/components/post/PublishPost.vue'
import api from "@/utils/api.js"
import { computed, onMounted, ref, watch } from 'vue';
import { useUser } from '@/utils/pinia'
import { Icon } from '@iconify/vue/dist/iconify.js';

const isloading = ref(false)
const user = useUser().getUser()
const currentPage = ref(1)
const pageSize = ref(5)
const record = ref({
  records: [],
  total: 0
})

onMounted(async () => {
  await getPost()
})

const getPost = async () => {
  isloading.value = true
  try {
    const res = await api.post('/user/post/page', {
      page: currentPage.value,
      pageSize: pageSize.value,
      loginUserId: user.id,
      status: 2
    })
    record.value.total = res.data.total
    record.value.records = res.data.records || []
  } catch (error) {
    console.error('获取帖子失败:', error)
  } finally {
    isloading.value = false
  }
}

// 监听页码变化
watch(currentPage, () => {
  getPost()
})

// 监听每页条数变化
watch(pageSize, () => {
  currentPage.value = 1
  getPost()
})

const handleSizeChange = (val) => {
  pageSize.value = val
}

const handleCurrentChange = (val) => {
  currentPage.value = val
}

const refresh = async () => {
  currentPage.value = 1
  await getPost()
}

const deletePost = (id) => {
    if (id <= 0) return; // Ensure the id is valid
    record.value.total -= 1;
    record.value.records = record.value.records.filter((item) => item.id !== id);
};
</script>

<template>
  <div class="min-h-[100svh] bg-slate-200 dark:bg-slate-900 relative py-6">
    <div class="max-w-2xl space-y-6 mx-auto px-4">
      <PublishPost @addPost="refresh" />
      
      <!-- 加载状态显示 -->
      <div v-if="isloading" class="flex justify-center py-4">
        <Icon icon="line-md:loading-loop" class="animate-spin w-8 h-8 text-main" />
      </div>

      <!-- 帖子列表 -->
      <div v-else class="space-y-6">
        <Post @del-post="deletePost" v-for="item in record.records" :post="item" :key="item.id" />
        
        <!-- 无数据显示 -->
        <div v-if="record.records.length === 0" 
          class="text-center py-8 text-gray-500 dark:text-gray-400">
          暂无帖子
        </div>
      </div>

      <!-- 分页器 -->
      <div class="flex justify-center py-4">
        <el-pagination
          hide-on-single-page
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :background="true"
          layout="prev, pager, next"
          :total="record.total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          class="bg-white dark:bg-slate-800 px-4 py-2 rounded-full shadow-sm"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
:deep(.el-pagination.is-background .el-pager li:not(.is-disabled).is-active) {
  background-color: rgb(34 197 94) !important;
}

:deep(.el-pagination.is-background .el-pager li:not(.is-disabled):hover) {
  color: rgb(34 197 94);
}

:deep(.el-select-dropdown__item.selected) {
  color: rgb(34 197 94);
}
</style>