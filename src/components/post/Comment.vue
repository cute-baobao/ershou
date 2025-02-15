<script setup lang="ts">
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Icon } from "@iconify/vue/dist/iconify.js";
</script>

<template>
    <div class="bg-white dark:bg-slate-800 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow duration-200">
        <div class="flex gap-4">
            <Avatar class="h-10 w-10">
                <AvatarImage src="https://github.com/shadcn.png" />
                <AvatarFallback>头像</AvatarFallback>
            </Avatar>
            <div class="flex-grow">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="font-semibold text-lg dark:text-white">我是你的爹✌</h3>
                    <span class="text-sm text-gray-500 dark:text-gray-400">2小时前</span>
                </div>
                <p class="text-gray-700 dark:text-gray-300 mb-3">
                    Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ex
                    voluptas placeat id eligendi sed magnam sunt aperiam cum
                    beatae et.
                </p>
                <div class="flex items-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                    <button class="flex items-center gap-1 hover:text-blue-500 dark:hover:text-blue-400">
                        <Icon icon="mdi:thumb-up-outline" />
                        <span>点赞 (15)</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>