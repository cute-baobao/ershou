<template>
    <Dialog :open="openDialog">
        <DialogTrigger :open="false" @click="openDialog = true">
            <Button class=" bg-blue-500 hover:bg-blue-600 text-white transition-colors duration-300" variant="outline">评论一下</Button>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>评论</DialogTitle>
                <DialogDescription>
                    这个商品您推荐购买吗？
                </DialogDescription>
            </DialogHeader>
            <div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right font-semibold text-xl">
                            评论：
                        </Label>
                        <Textarea @keyup.enter="postComment" maxlength="200" id="name" v-model="comment" class="col-span-3 resize-none" />
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
                <Button :disable="request" @click = "postComment" type="submit">
                    <span v-if="!request">发表评论</span>
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

import { Loader2 } from "lucide-vue-next"
import { useUser } from '@/utils/pinia'
import { watch, onMounted, ref } from 'vue';
import api from '@/utils/api'
import { info, success, warning } from '@/utils/message'
import { useRoute } from 'vue-router';
import { X } from "lucide-vue-next"

const openDialog = ref(false)
const emits = defineEmits(['update'])
// 引入路由
const route = useRoute()
// 页面数据
const rate = ref(0)
const request = ref(false)
const productId = route.query.productId
const comment = ref('')
const postComment = () => {
    if( comment.value.length < 5 )
        return info('评论内容不能少于5个字')
    request.value = true
    api({
        url:"/user/productComments/add",
        method:"POST",
        data:{
            productId:productId,
            content:comment.value
        }
    }).then(res => {
        if(res.code===1) {
            success('评论成功')
            comment.value = ''
            emits('update')
            openDialog.value = false
        }
    }).finally(()=> {
        request.value = false
    })
}
</script>
