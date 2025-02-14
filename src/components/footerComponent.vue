<template>
  <footer class="bg-gradient-to-r z-[1000] from-green-400 to-green-300 dark:from-slate-800 dark:to-slate-800 border-t border-solid border-gray-200 dark:border-gray-700 text-gray-800 dark:text-white py-8">
    <div class="container mx-auto px-4">
      <div class="grid md:grid-cols-4 gap-8">
        <div>
          <h3 class="text-lg font-semibold mb-4 flex items-center">
            <InfoIcon class="mr-2 h-5 w-5" />
            关于我们
          </h3>
          <p class="text-sm">小碳致力于推广可持续生活方式，为您提供高质量的二手商品。</p>
        </div>
        <div>
          <h3 class="text-lg font-semibold mb-4 flex items-center">
            <LinkIcon class="mr-2 h-5 w-5" />
            快速链接
          </h3>
          <ul class="space-y-2">
            <li v-for="link in quickLinks" :key="link.name">
              <a :href="link.path" class="text-sm hover:underline flex items-center hover:text-base hover:font-semibold">
                <ChevronRightIcon class="mr-1 h-4 w-4" />
                {{ link.name }}
              </a>
            </li>
          </ul>
        </div>
        <div>
          <h3 class="text-lg font-semibold mb-4 flex items-center">
            <PhoneIcon class="mr-2 h-5 w-5" />
            联系我们
          </h3>
          <p class="text-sm flex items-center">
            <MailIcon class="mr-2 h-4 w-4" />
            邮箱：2359376088@qq.com
          </p>
          <p class="text-sm flex items-center mt-2">
            <PhoneCallIcon class="mr-2 h-4 w-4" />
            电话：400-123-4567
          </p>
        </div>
        <div>
          <h3 class="text-lg font-semibold mb-4 flex items-center">
            <UsersIcon class="mr-2 h-5 w-5" />
            关注我们
          </h3>
          <div class="flex space-x-4">
            <a v-for="social in socialLinks" :key="social.name" :href="social.url" class="text-gray-600 dark:text-white hover:text-green-600 dark:hover:text-green-300 cursor-pointer">
              <span class="sr-only">{{ social.name }}</span>
              <component :is="social.icon" class="h-6 w-6" />
            </a>
          </div>
        </div>
      </div>
      <div class="mt-8 border-t border-gray-300 dark:border-gray-700 pt-8 text-sm text-center">
        <p class="flex items-center justify-center pb-2">
          <CopyrightIcon class="mr-2 h-4 w-4" />
          {{ new Date().getFullYear() }} 小碳二手交易平台. 保留所有权利.
        </p>
        <a href="https://beian.miit.gov.cn/" target="_blank">粤ICP备2025360858号-1</a>
      </div>
    </div>
  </footer> 
</template>

<script setup>
import { ref } from 'vue';
import { 
  Facebook, 
  Instagram, 
  Twitter, 
  Github, 
  InfoIcon, 
  LinkIcon, 
  ChevronRightIcon, 
  PhoneIcon, 
  MailIcon, 
  PhoneCallIcon, 
  UsersIcon,
  CopyrightIcon
} from 'lucide-vue-next';

const quickLinks = ref([
  { name: '我们的使命', path: 'https://cute-baobao.github.io/mission.html' },
  { name: '如何工作', path: 'https://cute-baobao.github.io/how-it-works.html' },
  { name: '常见问题', path: 'https://cute-baobao.github.io/faq.html' },
])

const socialLinks = ref([
  { name: 'Github', url: 'https://gitee.com/csgjf', icon: Github },
])
</script>