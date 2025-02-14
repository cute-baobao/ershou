<script setup lang="ts">
import Post from '@/components/post/Post.vue'
import PublishPost from '@/components/post/PublishPost.vue'
</script>

<template>
  <div class="min-h-[100svh] bg-slate-200 dark:bg-slate-900 relative py-6">
    <div class="max-w-2xl space-y-6 mx-auto px-4">
      <PublishPost />
      <div class="space-y-6">
        <Post v-for="i in 10" :key="i" />
      </div>
    </div>
  </div>
</template>