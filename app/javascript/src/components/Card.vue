<template>
  <p>
    {{ message }}
  </p>
</template>

<script>
import { ref } from 'vue'
import channelConsumer from 'channels/consumer'

export default {
  name: 'Card',
  setup() {
    channelConsumer.subscriptions.create("CardChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
      received(data) {
        console.log(data)
      }
    })
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
