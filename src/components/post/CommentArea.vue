<script setup lang="ts">
import { ref, nextTick, watch } from "vue";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Icon } from "@iconify/vue/dist/iconify.js";
import Comment from "./Comment.vue";

const comment = ref("")
const isExpanded = ref(false)
const commentSectionHeight = ref('0px')

const commentCount = 10 // 这里应该是一个动态值，根据实际评论数量来设置

const props = defineProps({
    id: {
        type: Number,
        required: true
    }
})
const toggleComments = () => {
    isExpanded.value = !isExpanded.value
    if (isExpanded.value) {
        nextTick(() => {
            const sectionHeight = document.querySelector('.comment-section')?.scrollHeight
            commentSectionHeight.value = `${sectionHeight}px`
        })
    } else {
        commentSectionHeight.value = '0px'
    }
}

const submitComment = () => {
    // 处理提交评论的逻辑
    console.log("Submitting comment:", comment.value)
    comment.value = "" // 清空输入框
}

watch(isExpanded, (newValue) => {
    console.log(newValue)
})
defineExpose({ toggleComments })
</script>

<template>
    <div class="overflow-hidden transition-all duration-300 ease-in-out"
         :style="{ maxHeight: isExpanded ? commentSectionHeight : '0px' }">
        <div class="comment-section w-full bg-slate-100 dark:bg-slate-700 p-4 rounded-lg shadow-inner">
            <h2 class="text-xl font-bold mb-6 flex items-center dark:text-white">
                <Icon icon="mdi:comment-text-outline" class="mr-2" />
                评论 
                <span class="ml-2 bg-blue-500 text-white text-sm px-2 py-1 rounded-full">{{ commentCount }}</span>
            </h2>
            
            <!-- 发表评论 -->
            <div class="flex w-full items-center gap-2 mb-6">
                <Input v-model="comment" type="text" placeholder="发表你的评论..." class="flex-grow dark:bg-slate-600 dark:text-white dark:placeholder-gray-400" />
                <Button @click="submitComment" class="flex items-center gap-1.5 dark:bg-blue-600 dark:hover:bg-blue-700" type="submit"> 
                    <Icon class="size-4" icon="ic:outline-send" />
                    发送
                </Button>
            </div>

            <div class="space-y-4 max-h-96 overflow-y-auto pr-2">
                <Comment v-for="item in commentCount" :key="item"/>
            </div>
        </div>
    </div>
</template>

<style scoped>
.comment-section {
    transform-origin: top;
    opacity: 1;
    transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
}
</style>