/// <reference types="vite/client" />

// 声明vue文件能被TypeScript识别
declare module '*.vue' {
    import type { DefineComponent } from 'vue';
    const component: DefineComponent<{}, {}, any>;
    export default component;
    }