<template>
  <p>
    {{ message }}
  </p>
</template>

<script>
import { ref } from 'vue'

export default {
  name: 'Card',
  setup() {
    const message = ref('ビンゴカード')
    
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
