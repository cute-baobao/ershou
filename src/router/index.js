//创建路由
import { KeepAlive } from "vue";
import { createRouter, createWebHistory } from "vue-router";
import { useToken } from "../utils/pinia";
const router = createRouter({
    //路由历史模式
    history: createWebHistory(),
    //路由映射列表
    routes: [
        {
            //路径
            path: '/index',
            //路由组件
            component: () => import('../pages/index.vue'),
        },
        {
            //路径
            path: '/detail',
            //路由组件
            component: () => import('../pages/detail.vue'),
        },
        {
            //路径
            path: '/login',
            //路由组件
            component: () => import('../pages/login.vue'),
        },
        {
            //路径
            path: '/chat',
            //路由组件
            component: () => import('../pages/chat.vue'),
        },
        {
            //路径
            path: '/write',
            //路由组件
            component: () => import('../pages/write.vue'),
        },
        {
            //路径
            path: '/personalCenter',
            //路由组件
            component: () => import('../pages/personalCenter.vue'),
        },
        {
            //路径
            path: '/update',
            name: 'update',
            //路由组件
            component: () => import('../pages/update.vue'),
        },
        {
            //路径
            path: '/more',
            //路由组件
            component: () => import('../pages/more.vue'),
        },
        {
            //路径
            path: '/orderCenter',
            //路由组件
            component: () => import('../pages/orderCenter.vue'),
        },
        {
            //路径
            path: '/order',
            //路由组件
            component: () => import('../pages/order.vue'),
        },
        {
            //路径
            path: '/success',
            //路由组件
            component: () => import('../pages/success.vue'),
        },
        {
            //路径
            path: '/sellerOrder',
            //路由组件
            component: () => import('../pages/sellerOrder.vue'),
        },
        {
            //路径
            path: '/userDetail',
            //路由组件
            component: () => import('../pages/userDetail.vue'),
        },
        {
            //路径
            path: '/404',
            //路由组件
            component: () => import('../pages/404page.vue'),
        },
        {
            //路径
            path: '/orderDetail',
            //路由组件
            component: () => import('../pages/orderDetail.vue'),
        },
        {
            path: '/pointStore',
            component: () => import('../pages/pointStore.vue'),
        },
        {
            path: '/pointOrder',
            component: () => import('../pages/pointOrder.vue'),
        },
        {
            path: '/pointOrderCenter',
            component: () => import('../pages/pointOrderCenter.vue'),
        },
        {
            path: '/fail',
            component: () => import('../pages/fail.vue'),
        },
        {
            path: '/',
            component: () => import('../pages/test.vue'),
        },
        {
            path: '/carbonComputed',
            component: () => import('../pages/carbonComputed.vue'),
        },
        {
            path: '/posts',
            component: () => import('../pages/posts.vue'),
        }
    ]
})

/**
 * 路由守卫
 * @param to 路由目标对象
 * @param from 路由来源对象
 * @param next 跳转函数
 */
router.beforeEach((to, from, next) => {
    const pathUrl = ['/about', '/login', '/detail', '/more', '/userDetail', '/pointStore', '/carbonComputed'];
    const token = useToken().getToken();
    const routeExists = router.getRoutes().some(route => {
        const pattern = new RegExp(`^${route.path.replace(/:\w+/g, '[^/]+')}$`);
        return pattern.test(to.path);
    });

    if (!routeExists) {
        // 路由存在，继续导航
        next({ path: '/404' });
        return
    }

    // 处理根路径
    if (to.path === '/') {
        next();
        return;
    }

    // 处理已登录用户访问登录页面
    if (to.path === '/login' && token) {
        next({ path: '/' });
        return;
    }

    // 检查路径是否在允许的路径列表中
    const isPathAllowed = pathUrl.some(path => new RegExp(`^${path}$`).test(to.path));

    if (!isPathAllowed) {
        if (token) {
            // 已登录放行
            next();
            return;
        } else {
            // 未登录重定向到登录页面
            next({
                path: '/login',
                query: { msg: "登陆后继续访问" }
            });
        }
    } else {
        // 路径在允许的列表中，直接放行
        next();
        return;
    }
});

export default router