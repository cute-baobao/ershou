<template>
    <div
        class="fixed top-[50%] translate-y-[-50%] right-0 hidden sm:hidden md:block lg:block xl:block z-50 bg-main/50 rounded-s-xl px-1 py-2"
    >
        <div class="flex flex-col gap-2">
            <router-link
                v-for="item in bar"
                :key="item.text"
                :to="item.to"
                class="w-10 h-10 flex flex-col justify-center items-center bg-white dark:bg-slate-800 rounded-full shadow-lg transition-all duration-300 hover:bg-green-100 dark:hover:bg-green-900 group"
            >
                <Icon
                    :icon="item.icon"
                    class="w-4 h-4 text-green-600 dark:text-green-400 transition-all duration-300 group-hover:scale-110"
                />
                <span
                    class="text-[10px] font-medium text-gray-600 dark:text-gray-300 group-hover:text-green-700 dark:group-hover:text-green-300"
                    >{{ item.text }}</span
                >
            </router-link>
            <button
                @click="goNotice"
                class="w-10 h-10 flex flex-col relative justify-center items-center bg-white dark:bg-slate-800 rounded-full shadow-lg transition-all duration-300 hover:bg-green-100 dark:hover:bg-green-900 group"
            >
                <span
                    v-if="unread > 0"
                    class="absolute -top-1 -right-1 w-4 h-4 flex justify-center items-center rounded-full bg-red-500 text-white text-xs font-bold"
                    >{{ unread }}</span
                >
                <Icon
                    icon="material-symbols:notifications"
                    class="w-4 h-4 text-green-600 dark:text-green-400 transition-all duration-300 group-hover:scale-110"
                />
                <span
                    class="text-[10px] font-medium text-gray-600 dark:text-gray-300 group-hover:text-green-700 dark:group-hover:text-green-300"
                    >通知</span
                >
            </button>
            <button
                @click="goBack"
                class="w-10 h-10 flex flex-col justify-center items-center bg-white dark:bg-slate-800 rounded-full shadow-lg transition-all duration-300 hover:bg-green-100 dark:hover:bg-green-900 group"
            >
                <Icon
                    icon="material-symbols:arrow-back-rounded"
                    class="w-4 h-4 text-green-600 dark:text-green-400 transition-all duration-300 group-hover:scale-110"
                />
                <span
                    class="text-[10px] font-medium text-gray-600 dark:text-gray-300 group-hover:text-green-700 dark:group-hover:text-green-300"
                    >返回</span
                >
            </button>
            <button
                @click="scrollToTop"
                class="w-10 h-10 flex flex-col justify-center items-center bg-white dark:bg-slate-800 rounded-full shadow-lg transition-all duration-300 hover:bg-green-100 dark:hover:bg-green-900 group"
                v-show="showTopButton"
            >
                <Icon
                    icon="material-symbols:arrow-upward-rounded"
                    class="w-4 h-4 text-green-600 dark:text-green-400 transition-all duration-300 group-hover:scale-110"
                />
                <span
                    class="text-[10px] font-medium text-gray-600 dark:text-gray-300 group-hover:text-green-700 dark:group-hover:text-green-300"
                    >顶部</span
                >
            </button>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { Icon } from "@iconify/vue/dist/iconify.js";
import { useRouter, useRoute } from "vue-router";
import api from "@/utils/api";

const unread = ref(0);
const router = useRouter();
const bar = ref([
    { icon: "material-symbols:home", text: "首页", to: "/index" },
    { icon: "material-symbols:add-box", text: "发布", to: "/write" },
    { icon: "material-symbols:chat", text: "聊天", to: "/chat" },
]);

const showTopButton = ref(false);

const scrollToTop = () => {
    window.scrollTo({
        top: 0,
        behavior: "smooth",
    });
};

const goBack = () => {
    router.go(-1);
};

const checkScroll = () => {
    showTopButton.value = window.pageYOffset > 300;
};

const getUnreadNotice = () => {
    api.get("/user/notice/getUnreadNum")
        .then((res) => {
            if (res.data > 0) unread.value = res.data;
        })
        .catch((err) => {
            console.log(err);
        });
};

const goNotice = () => {
    unread.value = 0;
    router.push("/notice");
};

onMounted(() => {
    getUnreadNotice();
    window.addEventListener("scroll", checkScroll);
});

onUnmounted(() => {
    window.removeEventListener("scroll", checkScroll);
});
</script>
