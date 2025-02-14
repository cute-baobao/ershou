<template>
    <!-- <Header /> -->
    <div
        class="w-full min-h-svh flex items-center justify-center bg-gradient-to-br from-gray-100 via-gray-200 to-gray-300 dark:from-slate-950 dark:via-slate-900 dark:to-slate-800 p-4 sm:p-6 md:p-8">
        <div class="w-full max-w-7xl">
            <div class="flex flex-col-reverse sm:flex-row gap-6 sm:gap-8">
                <div
                    class="flex-1 flex flex-col items-center w-full bg-white/90 dark:bg-slate-900/90 backdrop-blur-sm border-2 border-green-300 dark:border-green-800 rounded-lg shadow-lg space-y-4 p-6 transition-all duration-300 ease-in-out hover:shadow-xl">
                    <label
                        class="w-full p-6 border-2 border-dashed border-green-400 dark:border-green-700 rounded-lg bg-green-50 hover:bg-green-100 dark:bg-slate-800 dark:hover:bg-slate-700 transition-colors duration-300 cursor-pointer group">
                        <div
                            class="flex flex-col justify-center items-center space-y-2 text-green-600 dark:text-green-400 group-hover:text-green-700 dark:group-hover:text-green-300">
                            <Upload class="w-12 h-12 mb-2"></Upload>
                            <span class="font-semibold">点击上传图片</span>
                            <span class="text-sm">PNG, JPG (最大10MB)</span>
                        </div>
                        <Input class="w-full h-full hidden" type="file" @change="handlerUpload" multiple
                            accept="image/*"></Input>
                    </label>
                    <label class="font-semibold text-lg text-green-700 dark:text-green-400">已选图片</label>
                    <div v-if="imgList.length > 0" class="grid grid-cols-2 sm:grid-cols-3 gap-4 w-full">
                        <div v-for="(image, index) in imgList" :key="index" class="relative group">
                            <img :src="image.src" :alt="`Uploaded image ${index + 1}`"
                                class="w-full aspect-square object-cover rounded-lg border-2 border-green-200 dark:border-green-700 shadow-md transition-transform duration-300 group-hover:scale-105" />
                            <button @click="removeImage(index)"
                                class="absolute top-2 right-2 bg-red-500 text-white rounded-full p-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300 hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-400 focus:ring-opacity-50">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M6 18L18 6M6 6l12 12"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <Card
                    class="w-full flex-1 shadow-lg bg-white/90 dark:bg-slate-900/90 backdrop-blur-sm border-2 border-green-300 dark:border-green-800">
                    <CardHeader>
                        <CardTitle>
                            <div
                                class="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-2 sm:space-y-0">
                                <div class="text-3xl font-bold text-green-800 dark:text-green-300">
                                    发布闲置宝贝
                                </div>
                                <div class="text-sm font-medium text-green-600 dark:text-green-400">
                                    出售二手，减少碳足迹，为地球减负
                                </div>
                            </div>
                        </CardTitle>
                        <CardContent>
                            <form class="space-y-6">
                                <div class="grid sm:grid-cols-2 gap-6">
                                    <div class="sm:col-span-2 flex flex-col space-y-2">
                                        <label class="font-semibold text-green-700 dark:text-green-400"
                                            for="name">宝贝标题</label>
                                        <div class="relative">
                                            <Input id="name"
                                                class="bg-white/70 dark:bg-slate-800/70 text-gray-800 dark:text-green-200 placeholder-gray-500/50 dark:placeholder-green-400/50 pr-16 text-lg"
                                                minlength="5" maxlength="300" type="text" v-model="product.title"
                                                placeholder="输入标题（最多300字）" />
                                            <span
                                                class="absolute right-2 bottom-2 text-xs text-gray-500 dark:text-gray-400">
                                                {{ product.title.length }}/300
                                            </span>
                                        </div>
                                    </div>
                                    <div class="flex flex-col space-y-2">
                                        <label class="font-semibold text-green-700 dark:text-green-400"
                                            for="price">宝贝价格</label>
                                        <Input id="price"
                                            class="bg-white/70 dark:bg-slate-800/70 text-gray-800 dark:text-green-200 placeholder-gray-500/50 dark:placeholder-green-400/50"
                                            @update:model-value="priceHandleInput" v-model="product.price"
                                            placeholder="输入价格" />
                                    </div>
                                    <div class="flex flex-col space-y-2">
                                        <label class="font-semibold text-green-700 dark:text-green-400"
                                            for="freight">运费</label>
                                        <Input @update:model-value="freightHandleInput" id="freight"
                                            class="bg-white/70 dark:bg-slate-800/70 text-gray-800 dark:text-green-200 placeholder-gray-500/50 dark:placeholder-green-400/50"
                                            v-model="product.freight" placeholder="输入运费" />
                                    </div>
                                    <div class="flex flex-col space-y-2">
                                        <label class="font-semibold text-green-700 dark:text-green-400"
                                            for="category">宝贝分类</label>
                                        <Select v-model="product.categoryId">
                                            <SelectTrigger :id="product.categoryId"
                                                class="bg-white/70 dark:bg-slate-800/70 text-gray-800 dark:text-green-200">
                                                <SelectValue placeholder="选择分类" />
                                            </SelectTrigger>
                                            <SelectContent position="popper" class="max-h-[30svh]">
                                                <SelectItem v-for="item in categoryList" :key="item.id"
                                                    :value="String(item.id)">
                                                    {{ item.name }}
                                                </SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                </div>
                                <div class="flex flex-col space-y-2">
                                    <label class="font-semibold text-green-700 dark:text-green-400"
                                        for="desc">宝贝描述</label>
                                    <div class="relative">
                                        <Textarea id="desc"
                                            class="bg-white/70 dark:bg-slate-800/70 resize-none text-gray-800 dark:text-green-200 placeholder-gray-500/50 dark:placeholder-green-400/50 min-h-[100px] pr-16"
                                            minlength="5" maxlength="500" v-model="product.desc"
                                            placeholder="描述您的宝贝（最多500字）..."></Textarea>
                                        <span
                                            class="absolute right-2 bottom-2 text-xs text-gray-500 dark:text-gray-400">
                                            {{ product.desc.length }}/500
                                        </span>
                                    </div>
                                </div>
                            </form>
                            <Button :disabled="isloading"
                                class="mt-6 w-full bg-green-600 hover:bg-green-700 dark:bg-green-700 dark:hover:bg-green-600 text-white font-semibold py-3 rounded-lg transition-colors duration-300"
                                @click="publishProduct">
                                <span v-if="!isloading">发布</span>
                                <span v-else class="flex items-center justify-center">
                                    <Loader2 class="w-5 h-5 mr-2 animate-spin" />
                                    等待服务器处理中...
                                </span>
                            </Button>
                        </CardContent>
                    </CardHeader>
                </Card>
            </div>
        </div>
    </div>
</template>

<script setup>
import Header from "@/components/Header.vue";
import { Input } from "@/components/ui/input";
import { onMounted, ref, watch } from "vue";
import { Upload } from "lucide-vue-next";
import { Card, CardContent, CardTitle, CardHeader } from "@/components/ui/card";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";

import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { success, info, warning } from "@/utils/message";
import { Loader2 } from "lucide-vue-next";
import api from "@/utils/api";
import { useRouter } from "vue-router";
import lrz from "lrz"
//路由管理
const router = useRouter();
//加载
const isloading = ref(false);
//上传回显
const imgList = ref([]);
const fileList = ref([]);
const categoryList = ref([]);
// oss中的链接
const imgUrl = ref([]);
const product = ref({
    categoryId: "",
    price: "",
    title: "",
    desc: "",
    freight: "",
});

onMounted(() => {
    window.scrollTo(0, 0);
    getCategory();
});

const handlerUpload =async (event) => {
    const files = event.target.files;
    let length = 0;
    if (imgList.value.length + files.length - 1 > 5) {
        length = 5 - imgList.value.length + 1;
        info("最多上传6张图片");
    } else length = files.length;
    for (let i = 0; i < length; i++) {
        const file = files[i];
        //console.log(`img ${i+1}`,"before compress ",file.size/1024)
        if (file.type.indexOf("image") === -1) continue;
        await lrz(file, { quality: 0.5 }).then((rst) => {
            // 将压缩后的 Blob 转换为 File
            const compressedFile = new File([rst.file], file.name, { type: file.type });
            var image = new Image()
            image.src = rst.base64;
            imgList.value.push(image);
            fileList.value.push(compressedFile);
            //console.log(`img ${i+1}`,"after compress ",rst.fileLen/1024)
        });
    }
    event.target.value = null;
};

const getCategory = async () => {
    await api({
        url: "/admin/category/list",
        method: "GET",
    }).then((res) => {
        categoryList.value = res.data;
    });
};

const publishProduct = async () => {
    if (
        product.value.title === "" ||
        product.value.price === "" ||
        product.value.categoryId === "" ||
        product.value.desc === "" ||
        imgList.value.length === 0 ||
        product.value.freight === ""
    ) {
        info("请填写完整信息");
        return;
    }
    await uploadImg();
    isloading.value = true;
    await api({
        url: "/user/product/add",
        method: "POST",
        data: {
            title: product.value.title,
            price: Number(product.value.price),
            categoryId: Number(product.value.categoryId),
            desc: product.value.desc,
            image: imgUrl.value,
            freight: Number(product.value.freight),
        },
    })
    .then((res) => {
        if (res.code === 1) {
            success("发布成功,请等待审核通过");
            router.push({
                path: "/success",
                query: {
                    msg: "发布成功",
                },
            });
        }
    })
    .finally(() => {
        isloading.value = false;
    });
};

const removeImage = (index) => {
    // 不知道哪里出错了，可能是异步的问题，搞个定时
    setTimeout(()=>{
        imgList.value.splice(index, 1);
        fileList.value.splice(index, 1);
    },300)
};

const uploadImg = async () => {
    isloading.value = true;
    var params = new FormData();
    fileList.value.map((item) => {
        params.append("files", item); 
    });
    await api({
        url: "/common/upload",
        method: "POST",
        data: params,
        headers: {
            "Content-Type": "multipart/form-data",
        },
    })
    .then((res) => {
        if (res.code === 1) {
            imgUrl.value = res.data;
        }
    })
    .catch((err) => {
        warning("上传照片失败");
    })
    .finally(() => {
        isloading.value = false;
    });
};

const freightHandleInput = (value) => {
    // 确保输入的值是数字，并且不小于1
    //console.log(value)
    if (isNaN(value) || value < 1) {
        product.value.freight = 0; // 如果输入无效，则重置为1
    } else {
        product.value.freight = value; // 更新输入值
    }
};
const priceHandleInput = (value) => {
    // 确保输入的值是数字，并且不小于1
    if (isNaN(value) || value < 1) {
        product.value.price = 1; // 如果输入无效，则重置为1
    } else {
        //console.log(value)
        product.value.price = value; // 更新输入值
    }
};
</script>
