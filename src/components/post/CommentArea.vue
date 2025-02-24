<script setup lang="ts">
import { ref, nextTick, computed, watch } from "vue";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Icon } from "@iconify/vue/dist/iconify.js";
import Comment from "./Comment.vue";

import api from "@/utils/api.js";
import { useUser } from "@/utils/pinia/index.js";
import { success } from "@/utils/message.js";

const content = ref("");
const isLoading = ref(false);
const isExpanded = ref(false);
const currentPage = ref(1);
const pageSize = ref(5);

const comments = ref<{ total: number; records: any[] }>({
    total: 0,
    records: [],
});

// 修改获取评论的方法
const getComment = async () => {
    isLoading.value = true;
    try {
        const response = await api.get("/user/postComments/page", {
            params: {
                page: currentPage.value,
                pageSize: pageSize.value,
                postId: props.id,
                loginUserId: user.id,
            },
        });
        comments.value.total = response.data.total;
        comments.value.records = response.data.records || [];
    } catch (error) {
        console.error("Failed to fetch comments:", error);
    } finally {
        isLoading.value = false;
    }
};

// 修改提交评论的方法
const submitComment = async () => {
    if (!content.value) return;
    try {
        await api.post("/user/postComments/add", {
            postId: props.id,
            content: content.value,
        });
        content.value = "";
        currentPage.value = 1; // 重置到第一页
        await getComment(); // 重新获取评论列表
    } catch (error) {
        console.error("Failed to submit comment:", error);
    }
};

// 监听页码变化
watch(currentPage, () => {
    getComment();
});

// 处理页码变化
const handleCurrentChange = (val: number) => {
    currentPage.value = val;
};

// 处理每页条数变化
const handleSizeChange = (val: number) => {
    pageSize.value = val;
    currentPage.value = 1;
    getComment();
};

const commentSectionHeight = ref("0px");

const commentCount = computed(() => comments.value.total); // 这里应该是一个动态值，根据实际评论数量来设置
const user = useUser().getUser();
const props = defineProps({
    id: {
        type: Number,
        required: true,
    },
});

const toggleComments =async () => {
    isExpanded.value = !isExpanded.value
    if (comments.value.total === 0 && isExpanded.value) {
        await getComment();
    }
    if (isExpanded.value) {
         nextTick(() => {
            const sectionHeight = document.querySelector('.comment-section')?.scrollHeight
            commentSectionHeight.value = `${sectionHeight}px`
        })
    } else {
        commentSectionHeight.value = '0px'
    }
}

const deleteComment = (id: number) => {
    if (id <= 0) return; // Ensure the id is valid
    comments.value.total -= 1;
    comments.value.records = comments.value.records.filter((item: any) => item.id !== id);
    success("删除成功")
};

defineExpose({ toggleComments });
</script>

<template>
    <div class="overflow-hidden transition-all duration-300 ease-in-out"
        :style="{ maxHeight: isExpanded ? '' : '0px' }">
        <div class="comment-section w-full bg-slate-100 dark:bg-slate-700 p-4 rounded-lg shadow-inner">
            <h2
                class="text-xl font-bold mb-6 flex items-center dark:text-white"
            >
                <Icon icon="mdi:comment-text-outline" class="mr-2" />
                评论
                <span
                    class="ml-2 bg-blue-500 text-white text-sm px-2 py-1 rounded-full"
                    >{{ commentCount }}</span
                >
            </h2>

            <!-- 发表评论 -->
            <div class="flex w-full items-center gap-2 mb-6">
                <Input
                    @keyup.enter="submitComment"
                    v-model="content"
                    type="text"
                    placeholder="发表你的评论..."
                    class="flex-grow dark:bg-slate-600 dark:text-white dark:placeholder-gray-400"
                />
                <Button
                    @click="submitComment"
                    class="flex items-center gap-1.5 dark:bg-blue-600 dark:hover:bg-blue-700"
                    type="submit"
                >
                    <Icon class="size-4" icon="ic:outline-send" />
                    发送
                </Button>
            </div>

            <!-- 评论列表 -->
            <div class="space-y-4 max-h-[60vh] overflow-y-auto pr-2 custom-scrollbar">
                <Comment 
                    v-for="item in comments.records" 
                    @delete-comment="deleteComment" 
                    :comment="item" 
                    :key="item.id" 
                />
                
                <!-- 无评论时显示 -->
                <div v-if="comments.records.length === 0" 
                    class="text-center py-8 text-gray-500 dark:text-gray-400">
                    暂无评论
                </div>
            </div>

            <!-- 分页器 -->
            <div class="flex justify-center mt-4">
                <el-pagination
                    v-model:current-page="currentPage"
                    v-model:page-size="pageSize"
                    hide-on-single-page
                    :background="true"
                    layout=" prev, pager, next"
                    :total="comments.total"
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    class="bg-white dark:bg-slate-800 px-4 py-2 rounded-full shadow-sm"
                />
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

.custom-scrollbar {
    scrollbar-width: thin;
    scrollbar-color: #888888 #f1f1f1;
}

.custom-scrollbar::-webkit-scrollbar {
    width: 6px;
}

.custom-scrollbar::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
    background: #888888;
    border-radius: 3px;
}

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
