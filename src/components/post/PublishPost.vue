<script setup>
import { Button } from '@/components/ui/button'
import { Textarea } from '@/components/ui/textarea'
import { ref, computed } from 'vue'
import { Icon } from '@iconify/vue/dist/iconify.js';

const content = ref('')

const wordCount = computed(() => {
  return content.value.length
})

const toolbarButtons = [
  { icon: 'mdi:emoticon-outline', label: '表情' },
  { icon: 'mdi:image-outline', label: '图片' },
  { icon: 'mdi:at', label: '@用户' },
  { icon: 'mdi:chart-bar', label: '数据' },
  { icon: 'mdi:gift-outline', label: '礼物' },
]
</script>

<template>
  <div class="w-full bg-white dark:bg-slate-800 rounded-xl shadow-sm p-4">
    <Textarea
      v-model="content"
      placeholder="分享你的想法..."
      class="min-h-[120px] mb-4 resize-none focus:ring-2 focus:ring-blue-500 dark:bg-slate-700 dark:text-white dark:placeholder-gray-400"
    />

    <div class="flex items-center justify-between">
      <div class="flex items-center gap-2">
        <Button
          v-for="(btn, index) in toolbarButtons"
          :key="index"
          variant="ghost"
          size="sm"
          class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300 rounded-full"
        >
          <Icon :icon="btn.icon" class="w-5 h-5" />
        </Button>
      </div>

      <div class="flex items-center gap-3">
        <span class="text-sm text-gray-400 dark:text-gray-500">{{ wordCount }}</span>
        <Button variant="ghost" size="sm" class="text-gray-500 dark:text-gray-400 rounded-full">
          <Icon icon="mdi:video-outline" class="w-5 h-5" />
        </Button>
        <Button class="bg-blue-500 hover:bg-blue-600 text-white px-6 dark:bg-blue-600 dark:hover:bg-blue-700">
          发布
        </Button>
      </div>
    </div>
  </div>
</template>

<style scoped>
@reference "tailwindcss";
.button-hover {
  @apply transition-colors duration-200;
}
</style>