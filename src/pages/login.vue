<template>
  <div class="min-h-screen flex justify-center items-center bg-gradient-to-br from-green-100 to-blue-100 dark:from-slate-900 dark:to-slate-800 p-4">
    <div class="w-full max-w-md">
      <div class="text-center mb-8">
        <h1 class="text-4xl font-bold text-green-600 dark:text-green-400">小碳</h1>
        <p class="text-gray-600 dark:text-gray-300 mt-2">环保选择，智慧生活</p>
      </div>
      
      <Tabs default-value="login" class="w-full">
        <TabsList class="grid w-full grid-cols-2 mb-4">
          <TabsTrigger value="login" class="text-lg">登录</TabsTrigger>
          <TabsTrigger value="register" class="text-lg">注册</TabsTrigger>
        </TabsList>
        
        <TabsContent value="login">
          <Card class="border-green-200 dark:border-green-800 shadow-lg dark:bg-slate-800">
            <CardHeader class="space-y-1">
              <CardTitle class="text-2xl font-semibold flex items-center justify-center">
                <img src="@/assets/yezi.svg" class="h-8 w-8 mr-2" alt="logo">
                欢迎回来
              </CardTitle>
              <CardDescription>请输入您的账号和密码</CardDescription>
            </CardHeader>
            <CardContent>
              <div class="space-y-4">
                <div class="space-y-2">
                  <Label for="login-account" class="flex items-center">
                    <User class="mr-2 h-4 w-4" />
                    账号
                  </Label>
                  <Input id="login-account" v-model="loginInfo.account" placeholder="请输入您的账号" />
                </div>
                <div class="space-y-2">
                  <Label for="login-password" class="flex items-center">
                    <KeyRound class="mr-2 h-4 w-4" />
                    密码
                  </Label>
                  <div class="relative">
                    <Input 
                      type="password" 
                      v-model="loginInfo.password"
                      placeholder="请输入您的密码"
                    />
                  </div>
                </div>
              </div>
            </CardContent>
            <CardFooter class="flex flex-col space-y-4">
              <Button class="w-full" @click="login">
                <span v-if="!request">登录</span>
                <span v-else class="flex items-center justify-center">
                  <Loader2 class="w-4 h-4 mr-2 animate-spin" />
                  登录中...
                </span>
              </Button>
              <div class="text-center text-sm">
                <div @click="router.push({path:'/'})" class="text-green-600 hover:underline dark:text-green-400 cursor-pointer">
                  返回首页
                </div>
              </div>
            </CardFooter>
          </Card>
        </TabsContent>
        
        <TabsContent value="register">
          <Card class="border-green-200 dark:border-green-800 shadow-lg dark:bg-slate-800">
            <CardHeader class="space-y-1">
              <CardTitle class="text-2xl font-semibold flex items-center justify-center">
                <img src="@/assets/yezi.svg" class="h-8 w-8 mr-2" alt="logo">
                创建新账户
              </CardTitle>
              <CardDescription>请填写以下信息完成注册</CardDescription>
            </CardHeader>
            <CardContent>
              <div class="space-y-4">
                <div class="space-y-2">
                  <Label for="register-account" class="flex items-center">
                    <User class="mr-2 h-4 w-4" />
                    账号
                  </Label>
                  <Input id="register-account" v-model="registerInfo.account" placeholder="请设置您的账号" />
                </div>
                <div class="space-y-2">
                  <Label for="register-password" class="flex items-center">
                    <KeyRound class="mr-2 h-4 w-4" />
                    密码
                  </Label>
                  <div class="relative">
                    <Input 
                      id="register-password"
                      type="password" 
                      v-model="registerInfo.password"
                      placeholder="请设置您的密码"
                    />
                    
                  </div>
                </div>
                <div class="space-y-2">
                  <Label for="register-code" class="flex items-center">
                    <MessageSquare class="mr-2 h-4 w-4" />
                    验证码
                  </Label>
                  <div class="flex space-x-2">
                    <Input id="register-code" v-model="registerInfo.code" placeholder="请输入验证码" />
                    <Button v-if="!request" @click="sendCode">
                      <span v-if="!request && yzm.length === 0">获取验证码</span>
                      <span v-else-if="request" class="flex items-center">
                        <Loader2 class="w-4 h-4 mr-2 animate-spin" />
                        发送中...
                      </span>
                      <img v-else :src="yzm" class=" h-[140%] w-40" @click="sendCode" alt="验证码">
                    </Button>
                  </div>
                </div>
              </div>
            </CardContent>
            <CardFooter>
              <Button class="w-full" :disabled="registerInfo.code.length < 4" @click="register">
                <span v-if="!request">注册</span>
                <span v-else class="flex items-center justify-center">
                  <Loader2 class="w-4 h-4 mr-2 animate-spin" />
                  注册中...
                </span>
              </Button>
            </CardFooter>
          </Card>
        </TabsContent>
      </Tabs>
      
      <div class="mt-8 text-center text-sm text-gray-600 dark:text-gray-400">
        <p>登录即表示您同意我们的</p>
        <a href="#" class="text-green-600 hover:underline dark:text-green-400">服务条款</a>
        和
        <a href="#" class="text-green-600 hover:underline dark:text-green-400">隐私政策</a>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
  CardFooter
} from '@/components/ui/card'
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'
import { User, KeyRound, Mail, MessageSquare, Eye, EyeOff, Loader2 } from 'lucide-vue-next';
import { Label } from '@/components/ui/label';
import { onMounted, ref } from 'vue';
import api from '@/utils/api'
import { success, warning, info } from '@/utils/message'
import { useUser, useToken } from '@/utils/pinia'
import { useRouter, useRoute } from 'vue-router'

const request = ref(false)
// 倒计时六十秒
const isDisabled = ref(false)
const countdown = ref(60)

// 密码可视
const loginOpen = ref(false)
const registeropen = ref(false)

const yzm = ref('')

const router = useRouter()
const route = useRoute()
const token = useToken()
const user = useUser()
const loginInfo = ref({
  account: '',
  password: ''
})
const registerInfo = ref({
  account: '',
  password: '',
  code: '',
})

onMounted(() => {
  if (route.query.msg) {
    info(route.query.msg)
  }
  window.scrollTo(0, 0)
})

const login = async () => {
  if (loginInfo.value.account === "" && loginInfo.value.password === "") {
    info("账号或密码不能为空")
    return
  }
  request.value = true
  await api({
    method: "POST",
    url: '/user/user/login',
    data: {
      account: loginInfo.value.account,
      password: loginInfo.value.password
    }
  }).then(res => {
    if (res.code === 1) {
      success("登录成功，点击头像探索更多功能")
      user.setUser(res.data)
      token.setToken(res.data.token)
      router.push('/')
    }
  }).finally(() => {
    request.value = false
  })
}
//发送验证码
const sendCode = async () => {
  if (registerInfo.value.account==='') {
    warning("账号不能为空")
    return
  }
  request.value = true
  yzm.value = `${import.meta.env.VITE_APP_BASE_URL}/api/user/user/getCaptcha?account=${registerInfo.value.account}&${new Date().getTime()}`
  request.value = false
}

// 注册
const register = async () => {
  if (registerInfo.value.password === "" || registerInfo.value.account === "") {
    warning("请输入完整信息")
    return
  }
  request.value = true
  await api({
    method: "POST",
    url: '/user/user/add',
    data: {
      account: registerInfo.value.account,
      password: registerInfo.value.password,
      code: registerInfo.value.code
    }
  }).then(res => {
    if (res.code === 1) {
      success("注册成功")
      location.reload()
    }
  }).catch(err => {
    yzm.value = `${import.meta.env.VITE_APP_BASE_URL}/api/user/user/getCaptcha?account=${registerInfo.value.account}&${new Date().getTime()}`

  })
  .finally(() => {
    request.value = false
  })
}

const timer = () => {
  isDisabled.value = true
  setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      clearInterval(timer)
      isDisabled.value = false
      countdown.value = 60
    }
  }, 1000)
}
</script>