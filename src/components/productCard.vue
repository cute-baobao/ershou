<template>
    <router-link :key="product.productId" :to="'/detail?productId=' + product.productId"
        class="min-w-[170px] shadow-md max-w-[330px] aspect-[1.2/1.45] border-2 
        border-slate-200 dark:border-slate-900 border-solid rounded-2xl transition-color duration-300
         bg-emerald-50 hover:bg-gray-200 dark:bg-slate-800 dark:hover:bg-slate-700">
        <div  class="h-full w-full flex flex-col p-1 relative">
            <div
                class="flex-1 w-[100%] rounded-xl border border-[rgba(255,255,255,0)] border-solid overflow-hidden">
                <el-image :src="product.image" lazy class="w-full h-full" fit="cover" alt="商品图片" />
            </div>
            <div  class="aspect-[4/1] w-full p-1 space-y-1">
                <TooltipProvider>
                    <Tooltip :delayDuration="300">
                        <TooltipTrigger asChild>
                            <p
                                class="text-black dark:text-white text-md mb-4 line-clamp-1 overflow-hidden text-ellipsis hover:cursor-pointer">
                                {{ product.title }}
                            </p>
                        </TooltipTrigger>
                        <TooltipContent class="h-fit max-w-xs">
                            <p>{{ product.title }}</p>
                        </TooltipContent>
                    </Tooltip>
                </TooltipProvider>
                <div class="flex justify-between">
                    <div>
                        <div class="text-h4 text-orange-600 flex">
                            ￥{{ product.price }}
                        </div>
                    </div>
                    <div>
                        <div class="text-h4 text-h3c">
                            {{ product.collectionNum }}<span>人想要</span>
                        </div>
                    </div>
                </div>
            </div>
            <slot name="status">

            </slot>
        </div>
    </router-link>
</template>
<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider } from '@/components/ui/tooltip'
defineProps({
    product: {
        productId: Number,
        title: String,
        image: String,
        price: Number,
        collectionNum: Number,
        isSaled: Number
    }
});

const router = useRouter();
defineOptions({
    name: 'ProductCard'
})
</script>
<style scoped></style>
