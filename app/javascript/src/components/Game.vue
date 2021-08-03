<template>
  <p>
    {{ message }}
  </p>
</template>

<script>
import { ref } from 'vue'

export default {
  name: 'Game',
  setup() {
    const message = ref('ビンゴゲーム')
    
    return {
      message
    }
  }
}
</script>

<style scoped>
p {
  background-color: pink;
}
</style>
