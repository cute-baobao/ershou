<template>
    <Dialog>
        <DialogTrigger as-child>
            <Button>
                个人信息管理
            </Button>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>修改个人信息</DialogTitle>
                <DialogDescription>
                    在此处修改个人信息，保存后生效
                </DialogDescription>
            </DialogHeader>
            <div class="grid grid-cols-4 items-center gap-4">
                <Label for="username" class="text-right">
                    头像
                </Label>
                <Label>
                    <Avatar class="h-14 w-14">
                        <AvatarImage :src="userInfo.avatar" alt="@shadcn" />
                        <AvatarFallback>SC</AvatarFallback>
                    </Avatar>
                    <Input @change="handlerUpload" class="hidden" type="file" accept="image/*" />
                </Label>
            </div>
            <div class="grid gap-4 py-2">
                <div class="grid grid-cols-4 items-center gap-4">
                    <Label for="name" class="text-right">
                        用户名
                    </Label>
                    <Input id="name" v-model="userInfo.username" class="col-span-3" />
                </div>
            </div>
            <DialogFooter>
                <Button @click="updateUserInfo" type="submit">
                    <span v-if="!request">保存</span>
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
} from '@/components/ui/dialog'
import {
    Avatar,
    AvatarFallback,
    AvatarImage,
} from '@/components/ui/avatar'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

import { useUser } from '@/utils/pinia'
import { onMounted, ref } from 'vue';
import api from '@/utils/api'
import { success, warning } from '@/utils/message'
import {Loader2} from 'lucide-vue-next'

const request = ref(false)
const user = useUser()
const file = ref(null)
const userInfo = ref({
    username: '',
    avatar: '',
})

onMounted(() => {
    userInfo.value = { ...user.getUser() }
})


const handlerUpload = (event) => {
    const file1 = event.target.files[0]
    if (file1.type.indexOf('image') === -1)
        return
    file.value = file1
    const reader = new FileReader()
    reader.onload = (e) => {
        userInfo.value.avatar = e.target.result
    }
    reader.readAsDataURL(file1)
}

const uploadImg = async () => {
    var params = new FormData()
    params.append('files', file.value)
    await api({
        url: "/common/upload",
        method: "POST",
        data: params,
        headers: {
            'Content-Type': 'multipart/form-data'
        }
    }).then(res => {
        if (res.code === 1) {
            userInfo.value.avatar = res.data[0]
        }
    }).catch(err => {
        warning('上传照片失败')
    })
}

const updateUserInfo = async () => {
    request.value = true
    if (file.value !== null)
        await uploadImg()
    await api({
        url: '/user/user/update',
        method: 'PUT',
        data: {
            username: userInfo.value.username,
            avatar: userInfo.value.avatar
        }
    }).then(res => {
        if (res.code === 1) {
            user.setUserName(userInfo.value.username)
            user.setAvatar(userInfo.value.avatar)
            success('更新成功')
        }
    }).catch(err => {
        warning('更新失败')
    }).finally(() => {
        request.value = false
    })
}
</script>
