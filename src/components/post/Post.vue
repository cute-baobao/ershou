<script setup>
import { Avatar, AvatarImage, AvatarFallback } from '@/components/ui/avatar';
</script>
<template>
    <div>
        <div>
            <!-- 顶部header -->
            <div>
                <div>
                    <Avatar>
                        <AvatarImage src="https://github.com/shadcn.png" />
                        <AvatarFallback> 头像 </AvatarFallback>
                    </Avatar>
                </div>
                <div>
                    <div>用户名</div>
                    <div>发布时间</div>
                </div>
            </div>
            <!-- 内容了 -->
            <div>
            
            </div>
        </div>
    </div>
</template>