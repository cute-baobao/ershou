import { createApp } from 'vue'
import './assets/index.css'
import App from './App.vue'
import router from '@/router/index.js'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate  from 'pinia-plugin-persistedstate'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

const pinia = createPinia()
const app = createApp(App)
app.use(ElementPlus)
pinia.use(piniaPluginPersistedstate)
app.use(pinia)
app.use(router)
app.mount("#app")
