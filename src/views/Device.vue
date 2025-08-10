<script setup lang="ts"> 
import{ ref } from 'vue';
const deviceMemory = ref<number | undefined>((navigator as any).deviceMemory);
const core = ref<number | undefined>((navigator as any).hardwareConcurrency);
const platform = ref<string | undefined>((navigator as any).platform);
</script>
<template>
{{ deviceMemory }}GB
{{ core }}
{{ platform }}
</template>