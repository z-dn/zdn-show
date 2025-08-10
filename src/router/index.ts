import { createRouter, createWebHistory, type RouteRecordRaw, type Router } from 'vue-router';

import Home from '@/views/Home.vue';
import ClockRoutes from '@/router/Clock/index';
import Device from '@/views/Device.vue';

// 定义路由记录类型
const routes: Array<RouteRecordRaw> = [
    {
        path: '/',
        name: 'Home',
        component: () => Home,
        meta: { title: 'Home' }
    },
    ...ClockRoutes,
    {
        path: '/device',
        name: 'Device',
        component: () => Device,
        meta: { title: 'Device' }

    }
];

  // 创建路由实例
const router: Router = createRouter({
    history: createWebHistory(),
    routes
});

router.beforeEach((to) => { 
    to.meta.title && (document.title = to.meta.title)
});

export default router