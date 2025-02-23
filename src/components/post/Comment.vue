<script setup lang="ts">
import { onMounted, PropType, ref } from "vue";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Icon } from "@iconify/vue/dist/iconify.js";
import api from "@/utils/api.js"
import formatDate from "@/utils/timeUtils.js";

const emits = defineEmits(['deleteComment'])
// 正在处理点赞事件
const waitLike = ref(false)
const props = defineProps({
    comment: {
        type: Object as PropType<{
            avatar: string;
            canBeDeleted: boolean;
            content: string;
            createTime: string;
            id: number;
            likeNum: number;
            liked: boolean;
            userId: number;
            username: string;
        }>,
        require: true
    },
});

onMounted(() => {
    props.comment!.createTime = formatDate(props.comment!.createTime)
})

const toggleLike = () => {
    if (waitLike.value) return
    waitLike.value = true
    props.comment!.liked = !props.comment!.liked
    if (props.comment!.liked) {
        api.put(`/user/postComments/like?id=${props.comment?.id}`).then((res: any) => {
            if (res.code === 1) {
                console.log(res)
                props.comment!.likeNum += 1
            }
        }).finally(() => {
            waitLike.value = false
        })
    } else {
        api.put(`/user/postComments/cancelLike?id=${props.comment?.id}`, {
            id: props.comment!.id
        }).then((res: any) => {
            if (res.code === 1) {
                console.log(res)
                props.comment!.likeNum -= 1
            }
        }).finally(() => {
            waitLike.value = false
        })
    }
}

const deleteComment = () => {
    waitLike.value = true
    api.delete(`/user/postComments/delete?id=${props.comment?.id}`).then((res: any) => {
        if (res.code === 1) {
            console.log(res)
            emits('deleteComment', props.comment?.id)
        }
    })
}
</script>

<template>
    <div class="bg-white dark:bg-slate-800 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow duration-200">
        <div class="flex gap-4">
            <Avatar class="h-10 w-10">
                <AvatarImage :src="props.comment!.avatar" />
                <AvatarFallback>头像</AvatarFallback>
            </Avatar>
            <div class="flex-grow">
                <div class="flex items-center justify-between mb-2">
                    <h3 class="font-semibold text-lg dark:text-white">
                        {{ props.comment!.username }}
                    </h3>
                    <span class="text-sm text-gray-500 dark:text-gray-400">{{ props.comment?.createTime }}</span>
                </div>
                <p class="text-gray-700 dark:text-gray-300 mb-3">
                    {{ props.comment!.content }}
                </p>
                <div class="flex items-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                    <button @click="toggleLike" v-if="!props.comment!.liked"
                        class="flex items-center gap-1 hover:text-blue-500 dark:hover:text-blue-400">
                        <Icon icon="ri:thumb-up-line" />
                        <span>点赞 ({{ props.comment!.likeNum }})</span>
                    </button>
                    <button @click="toggleLike" v-else
                        class="flex items-center gap-1 hover:text-blue-500 dark:hover:text-blue-400">
                        <Icon icon="ri:thumb-up-fill" />
                        <span>点赞 ({{ props.comment!.likeNum }})</span>
                    </button>
                    <button @click="deleteComment" v-if="props.comment?.canBeDeleted"
                        class="flex items-center gap-1 hover:text-blue-500 dark:hover:text-blue-400">
                        <Icon class="size-4" icon="mdi:bin-outline" />
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
