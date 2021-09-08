import { createApp } from 'vue'
import Game from '@/components/Game.vue'
import Card from '@/components/Card.vue'

export default () => {
  window.addEventListener('load', () => {
    if (document.getElementById('game-vue')) {
      const gameApp = createApp(Game)
      gameApp.mount('#game-vue')
    }
    if (document.getElementById('card-vue')) {
      const cardApp = createApp(Card)
      cardApp.mount('#card-vue')
    }
  })
}
