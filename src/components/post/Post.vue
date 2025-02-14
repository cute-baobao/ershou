<script setup>
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Icon } from "@iconify/vue/dist/iconify.js";
import { ref } from "vue";

const imgList = ref([
    "/1.jpg",
    "/2.jpg",
    "/1.jpg",
    "/2.jpg",
    "/1.jpg",
    "/2.jpg",
    "/1.jpg",
    "/2.jpg",
    "/1.jpg",
]);
</script>

<template>
  <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm overflow-hidden">
    <div class="flex items-center justify-between p-4 border-b border-slate-100 dark:border-slate-700">
      <div class="flex items-center gap-3">
        <Avatar class="h-10 w-10">
          <AvatarImage src="https://github.com/shadcn.png" />
          <AvatarFallback>头像</AvatarFallback>
        </Avatar>
        <div>
          <div class="text-base font-medium dark:text-white">我是你的爹✌</div>
          <div class="text-sm text-gray-500 dark:text-gray-400">2023/05/06</div>
        </div>
      </div>
    </div>

    <div class="p-4 space-y-3">
      <div class="text-lg font-medium dark:text-white">
        Lorem ipsum dolor sit amet.
      </div>
      <div class="text-gray-600 dark:text-gray-300">
        Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum
        animi magni neque quod suscipit, ipsa dolores nihil sapiente
        impedit voluptatem optio in? Et voluptatem debitis tenetur iste
        ab sit rem.
      </div>
    </div>

    <div
      class="grid gap-2 px-2 py-2"
      :class="[
        imgList.length <= 2 ? 'grid-cols-2 pr-[20%]' : '',
        imgList.length === 3 ? 'grid-cols-3' : '',
        imgList.length === 4 ? 'grid-cols-2 pr-[20%]' : '',
        imgList.length > 5 ? 'grid-cols-3' : '',
      ]"
    >
      <el-image
        v-for="img in imgList"
        :key="img"
        :src="img"
        :preview-src-list="imgList"
        fit="cover"
        class="w-full h-full bg-white dark:bg-slate-700 border border-solid border-gray-100 dark:border-slate-600 rounded-md aspect-[1/0.8]"
      />
    </div>

    <div class="flex items-center justify-evenly py-3 border-t border-slate-100 dark:border-slate-700">
      <button class="flex items-center gap-2 px-4 py-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-700">
        <Icon icon="ri:thumb-up-line" class="w-5 h-5 text-gray-500 dark:text-gray-400" />
        <span class="text-sm text-gray-600 dark:text-gray-300">点赞</span>
      </button>
      <button class="flex items-center gap-2 px-4 py-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-700">
        <Icon icon="mdi:comment-outline" class="w-5 h-5 text-gray-500 dark:text-gray-400" />
        <span class="text-sm text-gray-600 dark:text-gray-300">评论</span>
      </button>
    </div>
  </div>
</template>