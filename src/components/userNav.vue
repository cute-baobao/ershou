<template>
    <DropdownMenu v-if="token.getToken() !== ''">
        <DropdownMenuTrigger as-child>
            <Button variant="ghost" class="relative h-8 w-8 rounded-full">
                <Avatar class="h-12 w-12">
                    <AvatarImage :src="user.avatar" alt="@shadcn" />
                    <AvatarFallback>SC</AvatarFallback>
                </Avatar>
            </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent class="w-56" align="end">
            <DropdownMenuLabel class="font-normal flex">
                <div class="flex flex-col space-y-1">
                    <p class="text-sm font-medium leading-none">
                        {{ user.username }}
                    </p>
                    <p class="text-xs leading-none text-muted-foreground">
                        {{ user.account }}
                    </p>
                </div>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuGroup>
                <DropdownMenuItem @click="router.push({ path: '/userDetail', query: { id: user.id } })">
                    <User class="mr-2 h-4 w-4" />
                    主页
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/personalCenter')">
                    <Settings class="mr-2 h-4 w-4" />
                    个人中心
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/write')">
                    <PlusCircle class="mr-2 h-4 w-4" />
                    发布宝贝
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/chat')">
                    <MessageCircle class="mr-2 h-4 w-4" />
                    消息
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/orderCenter')">
                    <ShoppingBag class="mr-2 h-4 w-4" />
                    订单
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/sellerOrder')">
                    <Store class="mr-2 h-4 w-4" />
                    卖家中心
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/pointStore')">
                    <Gift class="mr-2 h-4 w-4" />
                    积分商城
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/pointOrderCenter')">
                    <Package class="mr-2 h-4 w-4" />
                    积分商品订单
                </DropdownMenuItem>
                <DropdownMenuItem @click="router.push('/carbonComputed')">
                    <Package class="mr-2 h-4 w-4" />
                    碳足迹计算
                </DropdownMenuItem>
            </DropdownMenuGroup>
            <DropdownMenuSeparator />
            <DropdownMenuItem @click="logOut">
                <LogOut class="mr-2 h-4 w-4" />
                退出登录
            </DropdownMenuItem>
        </DropdownMenuContent>
    </DropdownMenu>
    <button v-else @click="logIn"
        class="bg-white text-green-600 px-4 py-2 rounded-full hover:bg-green-100 transition duration-300 flex items-center">
        <LogIn class="mr-1 h-4 w-4" />
        登录
    </button>
</template>

<script setup>
import {
    Avatar,
    AvatarFallback,
    AvatarImage,
} from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuShortcut,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
    User,
    Settings,
    PlusCircle,
    MessageCircle,
    ShoppingBag,
    Store,
    Gift,
    Package,
    LogOut,
    LogIn
} from 'lucide-vue-next'

import { useUser, useToken } from '@/utils/pinia'
import { useRouter } from 'vue-router'
const router = useRouter()
const user = useUser().getUser()
const token = useToken()
const logOut = () => {
    token.setToken('')
}

const logIn = () => {
    router.push('/login')
}
</script>
