<script setup lang="ts">
import { onMounted, onBeforeUnmount, watch, reactive, useTemplateRef} from 'vue';

let intervalId: number;

const timer = reactive({hours: '00', minutes: '00', seconds: 0});

onMounted(() => {
    updateClock();
    intervalId = setInterval(updateClock, 1000);
});
onBeforeUnmount(() => {
    clearInterval(intervalId);
});

const updateClock = () => {
    const now = new Date();
    timer.hours = now.getHours().toString().padStart(2,'0'); 
    timer.minutes = now.getMinutes().toString().padStart(2,'0'); 
    timer.seconds = now.getSeconds();
};

const clockFaceSecods = useTemplateRef('clock-face-seconds');


// 监听秒
watch(()=>timer.seconds,(newValue, oldValue)=>{
    console.log(newValue);
    (clockFaceSecods.value?.children[newValue] as HTMLElement).style.backgroundColor = '#FF4D4D';
    (clockFaceSecods.value?.children[oldValue] as HTMLElement).style.backgroundColor = '#374357';
});
</script>
<template>
    <div class="clock-container">
        <div class="clock">
            <div ref="clock-face-seconds" class="clock-face__seconds">
                <div class="clock-seconds__number" v-for="i in Array(60).keys()" :key="i" :style="{
                    transform: `rotate(${i * 6}deg) translateY(-130px)`,
                    height: i % 5 === 0 ? '10px' : '6px',
                    marginTop: i % 5 === 0 ? '-5px' : '-3px',
                    borderRadius: i % 5 === 0 ? '25%' : '50%'
                }">
                </div>
            </div>
            <div class="clock-face__digital">
                <div class="clock-face__digital-time">
                    {{ `${timer.hours}:${timer.minutes}` }}
                </div>
            </div>
        </div>
    </div>

</template>
<style lang="css" scoped>
.cloclk-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f0f0f0;
    font-family: Arial, sans-serif;
}

.clock {
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background-color: #fff;
    box-shadow: 0 0 20px #1A1F2B;
    border: #2C3A4F 5px solid;
    position: relative;
    box-sizing: border-box;
}

.clock-seconds-face {
    width: 100%;
    height: 100%;
    position: relative;
}
.clock-seconds__number {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    background-color: #374357;
    width: 6px;
    height: 6px;
    border-radius: 50%;
    margin-left: -3px;
    /* 子元素宽度的一半 */
    margin-top: -3px;
    /* 子元素高度的一半 */
}
.clock-face__digital{
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    border: 30px solid #e0e0e0;
    width: 50px;
    height: 50px;
    border-radius: 50%;
}
.clock-face__digital-time{
    position: absolute;
    left: 50%;
    top: 50%;
    font-size: 2rem;
    transform: translate(-50%, -50%);
    color: #1A1F2B;
}
</style>