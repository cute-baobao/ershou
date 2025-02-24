<script setup lang="ts">
import CommentArea from "./CommentArea.vue";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Icon } from "@iconify/vue/dist/iconify.js";
import Button from "../ui/button/Button.vue";

import { onMounted, PropType } from "vue";
import { ref } from "vue";
import api from "@/utils/api.js";
import formatDate from "@/utils/timeUtils.js";
import debounce from "@/utils/debounce.ts";
import { useUser } from "@/utils/pinia/index.js"

const userId = useUser().getUser().id;
const emits = defineEmits(["delPost"]);
const commentArea = ref();
const props = defineProps({
    post: {
        type: Object as PropType<{
            avatar: string;
            content: string;
            images: string[];
            createTime: string;
            id: number;
            likeNum: number;
            liked: boolean;
            userId: number;
            username: string;
            canBeDeleted: boolean;
        }>,
        require: true,
    },
});

onMounted(() => {
    props.post!.createTime = formatDate(props.post!.createTime);
});

const toggleLike = () => {
    props.post!.liked = !props.post!.liked;
    if (props.post!.liked) {
        api.put(`/user/post/like?id=${props.post?.id}`).then((res: any) => {
            if (res.code === 1) {
                console.log(res);
                props.post!.likeNum += 1;
            }
        });
    } else {
        api.put(`/user/post/cancelLike?id=${props.post?.id}`, {
            id: props.post!.id,
        }).then((res: any) => {
            if (res.code === 1) {
                console.log(res);
                props.post!.likeNum -= 1;
            }
        });
    }
};

const debounceToggleLike = debounce(toggleLike, 1000);

const delPost = () => {
    api.delete(`/user/post/delete?id=${props.post?.id}`).then((res: any) => {
        if (res.code === 1) {
            console.log(res);
            emits("delPost",props.post?.id);
        }
    });
};

const debounceDelPost = debounce(delPost, 1000);
</script>

<template>
    <div
        class="bg-white dark:bg-slate-800 rounded-xl shadow-sm overflow-hidden relative space-y-2"
    >
        <div
            class="flex items-center justify-between p-2 border-b border-solid border-slate-100 dark:border-slate-700"
        >
            <div class="flex items-center gap-3">
                <Avatar class="h-10 w-10">
                    <AvatarImage :src="props.post!.avatar" />
                    <AvatarFallback>头像</AvatarFallback>
                </Avatar>
                <div>
                    <div class="text-base font-medium dark:text-white">
                        {{ props.post!.username }}
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                        {{ props.post!.createTime }}
                    </div>
                </div>
            </div>
            <div v-if = "props.post?.userId === userId">
                <button
                    @click="debounceDelPost"
                    v-if="props.post?.canBeDeleted"
                    class="flex items-center gap-1 hover:text-blue-500 dark:hover:text-blue-400"
                >
                    <Icon class="size-4" icon="mdi:bin-outline" />
                </button>
            </div>
        </div>

        <div class="px-4">
            <div class="text-gray-600 dark:text-gray-300">
                {{ props.post!.content }}
            </div>
        </div>

        <div
            class="grid gap-2 px-4"
            :class="[
                props.post!.images?.length <= 2 ? 'grid-cols-2 pr-[20%]' : '',
                props.post!.images?.length === 3 ? 'grid-cols-3' : '',
                props.post!.images?.length === 4 ? 'grid-cols-2 pr-[20%]' : '',
                props.post!.images?.length > 5 ? 'grid-cols-3' : '',
            ]"
        >
            <el-image
                v-for="img in props.post?.images"
                :key="img"
                :src="img"
                :preview-src-list="props.post?.images"
                fit="cover"
                class="w-full h-full bg-white dark:bg-slate-700 border border-solid border-gray-100 dark:border-slate-600 rounded-md aspect-[1/0.8]"
            />
        </div>

        <div
            class="flex items-center justify-evenly border-t border-slate-100 dark:border-slate-700"
        >
            <Button
                @click="debounceToggleLike"
                variant="ghost"
                class="flex items-center gap-2 px-4 py-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-700"
            >
                <Icon
                    v-if="!props.post?.liked"
                    icon="ri:thumb-up-line"
                    class="w-5 h-5 text-gray-500 dark:text-gray-400"
                />
                <Icon
                    v-else
                    icon="ri:thumb-up-fill"
                    class="w-5 h-5 text-gray-500 dark:text-gray-400"
                />
                <span class="text-sm text-gray-600 dark:text-gray-300"
                    >点赞({{ props.post?.likeNum }})</span
                >
            </Button>
            <Button
                @click="commentArea.toggleComments()"
                variant="ghost"
                class="flex items-center gap-2 px-4 py-2 rounded-full hover:bg-slate-50 dark:hover:bg-slate-700"
            >
                <Icon
                    icon="mdi:comment-outline"
                    class="w-5 h-5 text-gray-500 dark:text-gray-400"
                />
                <span class="text-sm text-gray-600 dark:text-gray-300"
                    >评论</span
                >
            </Button>
        </div>
        <CommentArea :id="props.post!.id" ref="commentArea" />
    </div>
</template>
