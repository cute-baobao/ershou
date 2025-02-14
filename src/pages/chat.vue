<template>
  <div
    class="min-h-[90vh] bg-gradient-to-br from-blue-100 to-purple-100 dark:from-slate-900 dark:to-slate-800 p-4 sm:p-6 md:p-8 lg:p-10">
    <div class="max-w-5xl mx-auto bg-white dark:bg-slate-950 rounded-xl shadow-xl overflow-hidden">
      <div class="flex h-[80vh]">
        <ResizablePanelGroup direction="horizontal" class="w-full">
          <!-- 联系人列表 -->
          <ResizablePanel :default-size="25" :min-size="20" :max-size="40" class="bg-gray-50 dark:bg-slate-900">
            <div class="h-full flex flex-col">
              <div class="p-4 border-b bg-white dark:bg-slate-800 dark:border-slate-700">
                <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200">联系人</h2>
              </div>
              <div class="flex-1 overflow-y-auto">
                <ul class="divide-y divide-gray-200 dark:divide-slate-700">
                  <li v-for="contact in contacts" :key="contact.id" @click="selectContact(contact)"
                    class="hover:bg-gray-100 dark:hover:bg-slate-800 transition duration-150 ease-in-out cursor-pointer">
                    <div class="block px-4 py-4">
                      <div class="flex items-center space-x-4">
                        <div class="flex-shrink-0">
                          <img class="h-10 w-10 rounded-full" :src="contact.avatar" :alt="contact.username">
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-gray-900 dark:text-gray-200 truncate">
                            {{ contact.username }}
                          </p>
                          <p class="text-xs text-gray-500 dark:text-gray-400 truncate">
                            {{ contact.lastContent.includes("http") ? '[图片]' : contact.lastContent }}
                          </p>
                        </div>
                        <div class="flex items-center justify-center w-6 h-6">
                          <span :class="[
                            'w-full text-center text-sm rounded-full',
                            contact.unReadNum > 0 ? 'bg-red-600' : 'hidden'
                          ]">{{ contact.unReadNum }}</span>
                        </div>
                      </div>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </ResizablePanel>

          <ResizableHandle />

          <!-- 聊天窗口 -->
          <ResizablePanel class="bg-white dark:bg-slate-950">
            <div v-if="selectedContact !== null" class="h-full flex flex-col">
              <div class="bg-white dark:bg-slate-800 shadow-sm z-10">
                <div class="px-6 py-4 flex items-center space-x-4">
                  <img @click="userDetail(toUserId)" v-if="selectedContact" class="h-10 w-10 rounded-full cursor-pointer" :src="selectedContact.avatar"
                    :alt="selectedContact.name">
                  <div v-if="selectedContact">
                    <h2 class="text-lg font-semibold text-gray-900 dark:text-gray-200">{{ selectedContact.username }}
                    </h2>
                  </div>
                  <div v-else>
                    <h2 class="text-lg font-semibold text-gray-900 dark:text-gray-200">请选择一个联系人</h2>
                  </div>
                </div>
              </div>

              <div class="flex-1 overflow-y-auto p-6 space-y-4 dark:bg-slate-900" ref="chatContainer">
                <div v-for="(message, index) in currentMessages" :key="index"
                  :class="['flex flex-shrink-0', message.fromuserId === fromUserId ? 'justify-end' : 'justify-start']">
                  <div :class="[
                    'max-w-[50%] rounded-lg p-4 shadow-sm',
                    message.fromuserId === fromUserId
                      ? 'bg-blue-500 text-white dark:bg-blue-600'
                      : 'bg-gray-100 text-gray-800 dark:bg-slate-700 dark:text-gray-200',
                    message.type === 'img' ? 'max-w-[30%]' : ''
                  ]">
                    <el-image v-if="message.type === 'img'" :src="message.content" alt="发送的图片"
                      class="max-w-full h-auto rounded-lg" :preview-src-list="[message.content]" fit="contain"
                      :z-index="9999" />
                    <p v-else>{{ message.content }}</p>
                    <p :class="[
                      'text-xs mt-1',
                      message.fromuserId === fromUserId ? 'text-blue-100' : 'text-gray-400 dark:text-gray-500'
                    ]">{{ message.time }}</p>
                  </div>
                </div>
              </div>

              <div class="bg-white dark:bg-slate-800 border-t dark:border-slate-700 p-4">
                <form @submit.prevent="sendMessage" class="flex space-x-4">
                  <Input v-model="newMessage" placeholder="输入消息..."
                    class="flex-grow dark:bg-slate-700 dark:text-gray-200 dark:placeholder-gray-400"
                    :disabled="!selectedContact" />
                  <Button type="button" @click="openImageUpload" :disabled="!selectedContact"
                    class="dark:bg-slate-700 dark:text-gray-200">
                    <ImageIcon class="h-5 w-5" />
                  </Button>
                  <input type="file" ref="fileInput" @change="handleImageUpload" accept="image/*" class="hidden" />
                  <Button type="submit" :disabled="!selectedContact"
                    class="dark:bg-blue-600 dark:text-white">发送</Button>
                </form>
              </div>
            </div>
            <div class="flex items-center justify-center text-3xl font-semibold text-main h-[60vh]" v-else>
              选择一个联系人
            </div>
          </ResizablePanel>
        </ResizablePanelGroup>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch, onUnmounted } from 'vue'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { ResizablePanel, ResizablePanelGroup, ResizableHandle } from '@/components/ui/resizable'
import { ImageIcon } from 'lucide-vue-next'

import { useUser } from '@/utils/pinia'
import { useRoute, useRouter } from 'vue-router'
import api from '@/utils/api'
import dayjs from 'dayjs'
import { warning } from '@/utils/message'
import lrz from "lrz"

const open = ref(true)
const data = ref({})
// 路由管理
const connectNum = ref(0)
const fromUserId = useUser().getUser().id
const toUserId = ref(null)
const route = useRoute()
var socket = new WebSocket(import.meta.env.VITE_APP_WS + `/chat/${fromUserId}`);
//页面数据
const contacts = ref([])
const messages = ref([])
const selectedContact = ref(null)
const newMessage = ref('')
const chatContainer = ref(null)
const currentMessages = ref([])
const router = useRouter()
const msg = {
  method:3,
  data:{
    content:'聊天页 我还活着'
  }
}

//更改页面数据
const changePage = ref(false)
onMounted(async () => {
  window.scrollTo(0,0)
  scrollToBottom()
})

setInterval(() => {
  socket.send(JSON.stringify(msg));
}, 100000)

const selectContact = async (contact) => {
  //console.log(contact)
  toUserId.value = contact.toUserId
  selectedContact.value = contact
  contact.unReadNum = 0
  scrollToBottom()
}

const sendMessage = () => {
  if (newMessage.value.trim() && selectedContact.value) {
    let content = {
      touserId: String(toUserId.value),
      type: 1,
      content: newMessage.value
    }
    let data = {
      method: 2,
      data: content
    }
    if (socket.readyState === 1) {
      socket.send(JSON.stringify(data))
      newMessage.value = ''
    } else {
      warning('服务器错误')
      return
    }
    content.fromuserId = fromUserId
    content.type = 'text'
    content.time = dayjs().format('YYYY-MM-DD HH:mm')
    currentMessages.value.push(content)
    scrollToBottom()
  }
}

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}


watch(() => toUserId.value,async (newValue, oldValue) => {
  let data = {
    method: 1,
    data: {
      touserId: String(toUserId.value)
    }
  }
  if(socket && socket.readyState === 1) 
    socket.send(JSON.stringify(data))  
  changePage.value = true
})

socket.onopen = () => {
  //console.log(fromUserId + 'connect to ')
}

socket.onclose = () => {
  //console.log(fromUserId + 'disconnect to ')
}

socket.onmessage = async (event) => {
  let warningAudioDom = document.getElementById('warningAudio')

  //console.log(JSON.parse(event.data))
  if (open.value) {
    // 当聊天页第一次连接上websocket时，接受传送回来的联系人列表。
    let temp =  JSON.parse(event.data)
    contacts.value = temp
    console.log(contacts.value)
    if(route.query.toUserId !== undefined) {
      // 如果存在toUserId，则自动选择联系人
      //console.log(Number(route.query.toUserId))
      if(contacts.value === null) {
        await getUser(Number(route.query.toUserId),"")
        contacts.value = []
        contacts.value.unshift(data.value)
        selectContact(data.value)
        return
      }
      let contact = contacts.value.filter(item => item.toUserId === Number(route.query.toUserId))[0]
      if(contact === undefined) {
        await getUser(Number(route.query.toUserId),"")
        contacts.value.unshift(data.value)
        selectContact(data.value)
      }else {
        selectContact(contact)
      }
    }
    open.value = false
    scrollToBottom()
    return
  }

  if (changePage.value) {
    changePage.value = false
    // 当更换聊天页面时的逻辑，将聊天记录更开为新用户的
    currentMessages.value = JSON.parse(event.data)
    currentMessages.value = currentMessages.value.map(item => {
      item.time = dayjs(item.time).format('YYYY-MM-DD HH:mm')
      return item
    })
    scrollToBottom();
    return
  }

  var temp = JSON.parse(event.data)
  if (temp.fromuserId === toUserId.value) {
    // 得到ws的逻辑，并且发送消息的人，是正在聊天的人
    temp.time = dayjs(temp.time).format('YYYY-MM-DD HH:mm')
    currentMessages.value.push(temp)
    contacts.value.forEach(item => {
      if (item.toUserId === toUserId.value) {
        item.value = temp.content
      }
    })
  }else {
    // 当收到新消息，并且不是正在聊天的人
    let contact = contacts.value.filter(item=> {
      if(item.toUserId === temp.fromuserId) {
        return item
      }
    })[0]
    if(contact !== undefined) {
      // 如果有这个联系人，则更新他的消息
      contact.lastContent = temp.content 
      contact.unReadNum = contact.unReadNum + 1
    }else {
      await getUser(temp.fromuserId,temp.content)
      data.value.unReadNum = data.value.unReadNum + 1
      contacts.value.unshift(data.value)
    }
  }
  scrollToBottom()
}

const getUser = async (id,lastContent) => {
  await api({
    url: '/user/user/get',
    method: "GET",
    params: {
      id: id
    }
  }).then(res => {
    data.value = res.data
    data.value.lastContent = lastContent
    data.value.toUserId = id
    data.value.unReadNum = 0
  }).catch(err => {
    router.push('/404')
  })
}

// 新增的图片上传功能
const fileInput = ref(null)
const imgUrl = ref('')
const openImageUpload = () => {
  fileInput.value.click()
}

const handleImageUpload = async (event) => {
  const file = event.target.files[0]
  if (file && file.type.startsWith('image/')) {
    // console.log(file.size/1024)
    await lrz(file, { quality: 0.5 }).then((rst) => {
        // 将压缩后的 Blob 转换为 File
        const compressedFile = new File([rst.file], file.name, { type: file.type });
        imgUrl.value = compressedFile
        // console.log(rst.file.size/1024)
    });
    await uploadImg()
    sendImageMessage()
  }
}

const uploadImg = async () => {
  var params = new FormData()
  params.append('files', imgUrl.value)
  await api({
    url: "/common/upload",
    method: "POST",
    data: params,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  }).then(res => {
    if (res.code === 1) {
      imgUrl.value = res.data[0]
    }
  })
}

const sendImageMessage = async () => {
  if (selectedContact.value) {
    let content = {
      type: 2,
      content: imgUrl.value,
      touserId: String(toUserId.value),
    }
    let data = {
      method: 2,
      data: content
    }
    if (socket.readyState === 1) {
      socket.send(JSON.stringify(data))
    }
    content.fromuserId = fromUserId
    content.type = 'img'
    content.time = dayjs().format('YYYY-MM-DD HH:mm')
    currentMessages.value.push(content)
    scrollToBottom()
  }
}

const userDetail = (id) => {
  console.log(id)
  router.push({
    path: '/userDetail',
    query: {
      id: id
    }
  })
}

onUnmounted(() => {
  socket.close()
})
</script>