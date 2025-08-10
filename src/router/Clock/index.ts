import { type RouteRecordRaw } from 'vue-router';

const ClockRoutes: RouteRecordRaw[] = [
    {
        path: '/clock/simple',
        name: 'SimpleClock',
        component: () => import('@/views/Clock/Simple.vue'),
        meta: {
            title: '简单时钟'
        }
    },
    {
        path: '/clock/compass',
        name: 'CompassClock',
        component: () => import('@/views/Clock/Compass.vue'),
        meta: {
            title: '罗盘时钟'
        }
    },
];

export default ClockRoutes;