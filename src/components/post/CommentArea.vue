<script setup lang="ts">
import { ref, nextTick, watch, computed } from "vue";
import { Input } from "../ui/input";
import { Button } from "../ui/button";
import { Icon } from "@iconify/vue/dist/iconify.js";
import Comment from "./Comment.vue";

import api from "@/utils/api.js";
import { useUser } from "@/utils/pinia/index.js";

const content = ref("");
const isLoading = ref(false);
const isExpanded = ref(false);
const commentSectionHeight = ref("0px");

const commentCount = computed(() => comments.value.total); // 这里应该是一个动态值，根据实际评论数量来设置
const user = useUser().getUser();
const comments = ref<{ total: number; records: any[] }>({
    total: 0,
    records: [],
});
const page = ref(1);
const pageSize = ref(5);
const noMore = computed(() => comments.value.total === comments.value.records.length);

const props = defineProps({
    id: {
        type: Number,
        required: true,
    },
});

const toggleComments = () => {
    isExpanded.value = !isExpanded.value;
};

const submitComment = () => {
    if (!content.value) return;
    api.post("/user/postComments/add", {
        postId: props.id,
        content: content.value,
    }).then((res: any) => {
        console.log("Comment submitted successfully:", res);    
        content.value = "";
        getComment()
    }).catch((error:any) => {
        console.error("Failed to submit comment:", error);
    });
};

const getComment = async () => {
    isLoading.value = true;
    try {
        const response = await api.get("/user/postComments/page", {
            params: {
                page: page.value,
                pageSize: pageSize.value,
                postId: props.id,
                loginUserId: user.id,
            },
        });
        comments.value.total = response.data.total;
        if (response.data.records) {
            comments.value.records.push(...response.data.records);
        }
        nextTick(() => {
            const sectionHeight =
                document.querySelector(".comment-section")?.scrollHeight;
            commentSectionHeight.value = `${sectionHeight}px`;
        });
    } catch (error) {
        console.error("Failed to fetch comments:", error);
    } finally {
        isLoading.value = false;
    }
};

watch(isExpanded, async (newValue) => {
    if (comments.value.total === 0 && newValue) {
        await getComment();
    }
    if (newValue) {
        nextTick(() => {
            const sectionHeight =
                document.querySelector(".comment-section")?.scrollHeight;
            commentSectionHeight.value = `${sectionHeight}px`;
        });
    } else {
        commentSectionHeight.value = "0px";
    }
});

const loadMore = () => {
    if (isLoading.value) return;
    isLoading.value = true;
    page.value += 1;
    getComment();
};

const deleteComment = (id: number) => {
    if (id <= 0) return; // Ensure the id is valid
    comments.value.total -= 1;
    comments.value.records = comments.value.records.filter((item: any) => item.id !== id);
};

defineExpose({ toggleComments });
</script>

<template>
    <div
        class="overflow-hidden transition-all duration-300 ease-in-out"
        :style="{ maxHeight: isExpanded ? commentSectionHeight : '0px' }"
    >
        <div
            class="comment-section w-full bg-slate-100 dark:bg-slate-700 p-4 rounded-lg shadow-inner"
        >
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

            <div class="space-y-4 max-h-96 overflow-y-auto pr-2">
                <Comment v-for="item in comments.records" @delete-comment="deleteComment" :comment="item" :key="item" />
            </div>
            <div class="flex items-center justify-center mt-2">
                <span v-if="noMore" class="text-main font-mono "
                    >没有更多了</span
                >
                <span
                    @click="loadMore"
                    v-else-if="!isLoading"
                    class="hover:underline cursor-pointer active:text-main  font-mono"
                    >加载更多</span
                >
                <span v-else class="text-main font-mono flex items-center ">
                    <Icon icon="line-md:loading-loop" class="animate-spin" />
                    加载中...
                </span>
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
