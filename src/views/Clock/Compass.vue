<script lang="ts" setup>
import {watch,ref,reactive,useTemplateRef, onMounted, onUnmounted} from 'vue';

let timerId: number;

const timer = reactive({
    month: 1,
    day: 1,
    hours: 0,
    minutes: 0,
    seconds: 0,
});
const updateClock = () =>{ 
    const now = new Date();
    timer.month = now.getMonth();
    timer.day = now.getDay();
    timer.hours = now.getHours();
    timer.minutes = now.getMinutes();
    timer.seconds = now.getSeconds();
}

onMounted(()=>{
    console.log(secondsDegree);
    updateClock();
    timerId = setInterval(updateClock, 1000)
});
onUnmounted(()=>{ 
    clearInterval(timerId)
});

// 秒
const secondsDegree = ref<number>(0)
const secondsIndex = ref<number>(0)
watch(()=>timer.seconds, (newValue, oldValue)=>{ 
    if(newValue===0&& oldValue===59){
        secondsDegree.value = (secondsDegree.value+6);
    }else{
        secondsDegree.value = (secondsDegree.value+(Math.abs(newValue - oldValue))*6);
    }
    secondsIndex.value = newValue;
})

// 分
const minutesDegree = ref<number>(0)
const minutesIndex = ref<number>(0)
watch(()=>timer.minutes, (newValue, oldValue)=>{ 
    minutesDegree.value = newValue===0 && oldValue===59 ? secondsDegree.value+6 : minutesDegree.value+(Math.abs(newValue - oldValue))*6;
    minutesIndex.value = newValue;
})

// 时
const hoursDegree = ref<number>(0)
const hoursIndex = ref<number>(0)
watch(()=>timer.hours, (newValue, oldValue)=>{ 
    hoursDegree.value = newValue===0 && oldValue===23 ? minutesDegree.value+15 : hoursDegree.value+(Math.abs(newValue - oldValue))*15;
    hoursIndex.value = newValue;
})


// 日
const daysNumerber = reactive<number[]>([31,28,31,30,31,30,31,31,30,31,30,31])
const dayDegree = ref<number>(0)
const dayIndex = ref<number>(0)
watch(()=>timer.day, (newValue, oldValue)=>{ 
    console.log(newValue, oldValue);
    dayDegree.value = newValue===1 && oldValue===31 ? hoursDegree.value+ (360/daysNumerber[newValue]): dayDegree.value+(Math.abs(newValue - oldValue))*(360/daysNumerber[newValue]);
    dayIndex.value = newValue;
})

// 年、月、日、星期

</script>
<template>
    <div class="clock-container">
        <div class="clock">
            <div class="second-box" :style="{transform: `rotate(${secondsDegree}deg)`}">
                <div v-for="i in Array(60).keys()" :id="`second_${i}`" :key="i"
                    :class="{'now-date': secondsIndex === i}"
                    :style="{ fontSize: '0.8rem', width: '100%', textAlign: 'right', position: 'absolute', display: 'inline-block', transform: `rotate(${(i*-6)}deg)` }">
                    {{ i.toString().padStart(2,'0') }}sec
                </div>
            </div>
            <div class="minute-box" :style="{transform: `rotate(${minutesDegree}deg)`}">
                <div v-for="i in Array(60).keys()" :id="`minute_${i}`" :key="i"
                    :class="{'now-date': minutesIndex === i }"
                    :style="{ fontSize: '0.8rem', width: '100%', textAlign: 'right', position: 'absolute', display: 'inline-block', transform: `rotate(${i * -6}deg)` }">
                    {{ i.toString().padStart(2,'0') }}min
                </div>
            </div>
            <div class="hour-box" :style="{ transform: `rotate(${hoursDegree}deg)` }">
                <div v-for="i in Array(24).keys()" :id="`hour_${i}`" :key="i"
                    :class="{'now-date': hoursIndex === i}"
                    :style="{ fontSize: '0.8rem', width: '100%', textAlign: 'right', position: 'absolute', display: 'inline-block', transform: `rotate(${i * -15}deg)` }">
                    {{ i.toString().padStart(2,'0') }}h
                </div>
            </div>
            <div class="day-box" :style="{ transform: `rotate(${dayDegree}deg)` }">
                <div v-for="i in daysNumerber[timer.month]" :key="i"
                :style="{ fontSize: '0.8rem', width: '100%', textAlign: 'right', position: 'absolute', display: 'inline-block', transform: `rotate(${(i-1) * -(360/daysNumerber[timer.month])}deg)` }">
                
                    {{ i.toString().padStart(2,'0') }}d
                </div>
            </div>
            <div class="month-box"></div>
            <div class="year-box"></div>
        </div>
    </div>


</template>
<style lang="css" scoped>
.clock-container {
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
}

.clock {
    width: 100%;
    height: 100%;
    background-color: #141929;
    position: absolute;
    display: flex;
    justify-content: center;
    align-items: center;
    color: rgba(255, 255, 255, 0.5);
    overflow: hidden;
}

/* 当前时间 */
.now-date {
    color: rgba(255, 255, 255, 1);
}

.year-box {
    width: 10vh;
    height: 10vh;
    position: absolute;
    display: flex;
    font-size: 20px;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
    background-image: -webkit-linear-gradient(bottom, yellow, red);
    background-size: 100% 20px;
    background-clip: text;
    -webkit-text-fill-color: transparent;
}

.month-box {
    width: 25vh;
    height: 25vh;
    position: absolute;
    display: flex;
    font-size: 20px;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
}

.day-box {
    width: 18vw;
    height: 18vw;
    position: absolute;
    display: flex;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
}

.hour-box {
    width: 25vw;
    height: 25vw;
    position: absolute;
    display: flex;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
}

.minute-box {
    width: 35vw;
    height: 35vh;
    position: absolute;
    display: flex;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
}

.second-box {
    width: 45vw;
    height: 45vh;
    position: absolute;
    display: flex;
    align-items: center;
    border-radius: 50%;
    transition: 1s;
}
</style>