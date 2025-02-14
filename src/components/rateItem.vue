<template>
    <Dialog :open="openDialog">
        <DialogTrigger :open="false" @click="openDialog = true">
            <Button class="bg-gray-50" variant="outline">评价</Button>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>评价</DialogTitle>
                <DialogDescription>
                    这次购物体验如何，请给出您的评价
                </DialogDescription>
            </DialogHeader>
            <div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label class="text-right font-semibold text-xl" for="rate">评分：</Label>
                        <el-rate v-model="rate" size="large" />
                    </div>
                </div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right font-semibold text-xl">
                            评价：
                        </Label>
                        <Textarea @keyup.enter="submit" v-model="content" maxlength="200" id="name" class="col-span-3 resize-none" />
                    </div>
                </div>
            </div>
            <template #close>
                <DialogClose
                    class="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground" @click="openDialog = false"
                >
                    <X class="w-4 h-4" />
                    <span class="sr-only">Close</span>
                </DialogClose>
            </template>
            <DialogFooter>
                <Button @click="submit">
                    <span v-if="!request">提交</span>
                        <span v-else class="flex items-center">
                            <Loader2 class="w-4 h-4 mr-2 animate-spin"/>
                            loading
                        </span>
                </Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
</template>

<script setup>
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
    DialogClose
} from '@/components/ui/dialog'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';

import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { useRouter } from 'vue-router';
import { X, Loader2 } from "lucide-vue-next"

const props = defineProps({
    orderId: Number,
    userId: Number
})
const emits = defineEmits(['update'])
// 引入路由
const openDialog = ref(false)
const router = useRouter()
// 页面数据
const rate = ref(0)
const request = ref(false)
const content = ref("")

const submit = () => {
    if(rate.value===0 && content.value==="")
        return warning('请输入评价')
    request.value = true
    api({
        url:'/user/userComments/add',
        method:"POST",
        data:{
            targetUserId: props.userId,
            orderId: props.orderId,
            content: content.value,
            score: rate.value
        }
    }).then(res => {
        success('评价成功')
        emits('update')
        openDialog.value = false
    }).catch(err => {
        warning('评价失败')
    }).finally(() => {
        request.value = false
    })
}
</script>
