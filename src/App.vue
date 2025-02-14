<template>
  <div class=" relative">
    <Toaster/>
    <div>
      <Header v-if="route.path != '/login'"/>
      <router-view/>
    </div>
    <sidebar/>
  </div>
</template>
<script setup>
import { Toaster } from '@/components/ui/toast'
import  sidebar from '@/components/sidebar.vue'
import Header from './components/Header.vue';
import { useRoute, useRouter } from 'vue-router';
import { useUser } from '@/utils/pinia'
import { onMounted, ref } from 'vue';
import { success } from '@/utils/message'
import footerComponent from './components/footerComponent.vue';

const user = useUser()
const fromUser = user.getUser().id;
let ws = null;
const open = ref(true)
const route = useRoute()
const router = useRouter()
const msg = {
  method:3,
  data:{
    content:'首页 我还活着'
  }
}

onMounted(()=>{
  document.title = "小碳二手交易平台"
  ws = new WebSocket(import.meta.env.VITE_APP_WS+`/chat/${fromUser}`)
  ws.onmessage = onmessage;
  
})



setInterval(() => {
  ws.send(JSON.stringify(msg));
}, 100000)

const onmessage = (event)=> {
  if(open.value) {
    open.value = false
    return
  }
  
  var temp = JSON.parse(event.data)
  if(temp.type === 'text' && route.path !== '/chat') {
    success("您有一条未读消息")
  }
}
</script>