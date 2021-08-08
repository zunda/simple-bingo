<template>
  <p>
    {{ message }}
  </p>
</template>

<script>
import { ref } from 'vue'
import createCardChannel from 'channels/card_channel.js'

export default {
  name: 'Card',
  setup() {
    createCardChannel()
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
