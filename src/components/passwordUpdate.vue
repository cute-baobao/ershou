<template>
    <Dialog>
        <DialogTrigger as-child>
            <Button class="text-black dark:text-white" variant="outline">修改密码</Button>
        </DialogTrigger>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>修改密码</DialogTitle>
                <DialogDescription>
                    在此处修改密码，新密码不能和旧密码相同。
                </DialogDescription>
            </DialogHeader>
            <div class="space-y-2">
                <div class="grid grid-cols-4 items-center gap-4">
                    <Label class="text-right">
                        旧密码
                    </Label>
                    <div class="col-span-3 relative">
                        <Input :class="oldpwdTrue===false?'border-red-700':''" @blur="verifyPwd" required v-model="passwordUpdate.oldpwd"/>
                        <span class="absolute end-2 inset-y-0 flex items-center justify-center">
                            <span v-if="oldpwdTrue!==null">
                                <X v-if="!oldpwdTrue" class="size-6 text-muted-foreground text-red-700" />
                                <Check v-else class="size-6 text-muted-foreground text-green-700" />
                            </span>
                        </span>
                    </div>
                </div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right">
                            新密码
                        </Label>
                        <Input v-model="passwordUpdate.newpwd" id="name" class="col-span-3" required />
                    </div>
                </div>
                <div class="grid gap-4 py-2">
                    <div class="grid grid-cols-4 items-center gap-4">
                        <Label for="name" class="text-right">
                            确认密码
                        </Label>
                        <Input id="name" class="col-span-3" required v-model="passwordUpdate.confirm"/>
                    </div>
                </div>
                <div class="flex justify-end">
                    <Button :disabled="!oldpwdTrue" @click="updatePwd">
                        <span v-if="!request">修改密码</span>
                        <span v-else class="flex items-center">
                            <Loader2 class="w-4 h-4 mr-2 animate-spin"/>
                            loading
                        </span>
                    </Button>
                </div>
            </div>
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
import { Award,X,Check,Loader2 } from 'lucide-vue-next';

import { useUser } from '@/utils/pinia'
import { onMounted, ref } from 'vue';
import api from '@/utils/api'
import { success, warning,info } from '@/utils/message'
import {useToken} from '@/utils/pinia'
import { useRouter } from 'vue-router';

const token = useToken()
const oldpwdTrue = ref(null)
const router = useRouter()
const request = ref(false)
const passwordUpdate = ref({
    oldpwd:'',
    newpwd:'',
    confirm:''
})

const verifyPwd = ()=> {
    if(passwordUpdate.value.oldpwd==='') {
        oldpwdTrue.value = false
        return
    }
    api({
        url:'/user/user/verifyPwd',
        method:'GET',
        params:{
            password:passwordUpdate.value.oldpwd
        }
    }).then(res=>{
        if(res.code===1) {
            oldpwdTrue.value = true
        }else {
            oldpwdTrue.value = false
            warning('旧密码错误')
        }
    })
}

const updatePwd = ()=> {
    if(passwordUpdate.value.newpwd !== passwordUpdate.value.confirm) {
        info('两次密码不一致')
        return false
    }
    if(passwordUpdate.value.newpwd === passwordUpdate.value.oldpwd) {
        info('新密码不能和旧密码相同')
        return false
    }
    request.value = true
    api({
        url:'/user/user/updatePwd',
        method:'PUT',
        data:{
            newPassword:passwordUpdate.value.newpwd,
            newPasswordAgain:passwordUpdate.value.confirm
        }
    }).then(res=>{
        if(res.code===1) {
            token.setToken('')
            success('密码修改成功,请重新登录')
            router.push('/login')
        }
    }).finally(()=>{
        request.value = false
    })
}

</script>
