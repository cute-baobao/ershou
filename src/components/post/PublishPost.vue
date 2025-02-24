<script setup>
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Icon } from "@iconify/vue/dist/iconify.js";

import { ref, computed } from "vue";
import api from "@/utils/api.js";
import lrz from "lrz";
import { info } from "@/utils/message.js";

const content = ref("");

//上传回显
const imgList = ref([]);
const fileList = ref([]);
const imgUrl = ref([]);

const isloading = ref(false);

const wordCount = computed(() => {
    return content.value.length;
});

const emits = defineEmits(["addPost"]);

const addPost = async () => {
    isloading.value = true;
    let img = false;
    if (!content.value) return;
    if (imgList.value.length > 0) {
        await uploadImg();
        img = true;
    }
    api.post("/user/post/add", {
        content: content.value,
        urls: img ? imgUrl.value : [],
    })
    .then((res) => {
        if (res.code === 1) {
            content.value = "";
            imgUrl.value = [];
            imgList.value = [];
            fileList.value = [];
            emits("addPost");
        }
    })
    .finally(() => {
        isloading.value = false;
    });
};

const handlerUpload = async (event) => {
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
            const compressedFile = new File([rst.file], file.name, {
                type: file.type,
            });
            var image = new Image();
            image.src = rst.base64;
            imgList.value.push(image);
            fileList.value.push(compressedFile);
            //console.log(`img ${i+1}`,"after compress ",rst.fileLen/1024)
        });
    }
    event.target.value = null;
};

const removeImage = (index) => {
    imgList.value.splice(index, 1);
    fileList.value.splice(index, 1);
};

const uploadImg = async () => {
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
        });
};
</script>

<template>
    <div class="w-full bg-white dark:bg-slate-800 rounded-xl shadow-sm p-4">
        <Textarea
            v-model="content"
            placeholder="分享你的想法..."
            class="min-h-[120px] mb-4 resize-none focus:ring-2 focus:ring-blue-500 dark:bg-slate-700 dark:text-white dark:placeholder-gray-400"
        />
        <div
            class="grid gap-2 px-2 py-2"
            :class="[
                imgList.length <= 2 ? 'grid-cols-2 pr-[20%]' : '',
                imgList.length === 3 ? 'grid-cols-3' : '',
                imgList.length === 4 ? 'grid-cols-2 pr-[20%]' : '',
                imgList.length > 5 ? 'grid-cols-3' : '',
            ]"
        >
            <!-- 修改 el-image 外层容器 -->
            <div
                v-for="(image, index) in imgList"
                :key="index"
                class="relative group"
            >
                <el-image
                    :src="image.src"
                    fit="cover"
                    class="w-full h-full bg-white dark:bg-slate-700 border border-solid border-gray-100 dark:border-slate-600 rounded-md aspect-[1/0.8]"
                />
                <!-- 移除按钮 -->
                <button
                    @click.stop="removeImage(index)"
                    class="absolute -right-2 -top-2 opacity-0 group-hover:opacity-100 transition-opacity duration-200 bg-red-500 rounded-full p-1 hover:bg-red-600 z-10"
                >
                    <Icon icon="mdi:close-circle" class="w-6 h-6 text-white" />
                </button>
            </div>
        </div>
        <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
                <Button
                    variant="ghost"
                    size="sm"
                    class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300 rounded-full"
                >
                    <Icon icon="mdi:emoticon-outline" class="w-5 h-5" />
                </Button>
                <label
                    class="text-gray-500 p-2 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300 rounded-full cursor-pointer"
                >
                    <Icon icon="mdi:image-outline" class="w-5 h-5" />
                    <input
                        @change="handlerUpload"
                        multiple
                        accept="image/*"
                        type="file"
                        class="hidden"
                    />
                </label>
            </div>

            <div class="flex items-center gap-3">
                <span class="text-sm text-gray-400 dark:text-gray-500">{{
                    wordCount
                }}</span>
                <Button
                    @click="addPost"
                    :disabled="isloading"
                    class="bg-blue-500 hover:bg-blue-600 text-white px-6 dark:bg-blue-600 dark:hover:bg-blue-700"
                >
                    <Icon
                        v-if="isloading"
                        icon="mdi:loading"
                        class="w-5 h-5 animate-spin"
                    />
                    <span v-else>发布</span>
                </Button>
            </div>
        </div>
    </div>
</template>

<style scoped>
@reference "tailwindcss";
.button-hover {
    @apply transition-colors duration-200;
}
</style>
