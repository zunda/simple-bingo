import { createApp } from 'vue'
import Game from '@/components/Game.vue'
import Card from '@/components/Card.vue'

export default () => {
  document.addEventListener('DOMContentLoaded', () => {
    const gameApp = createApp(Game)
    gameApp.mount('#game-app')
    const cardApp = createApp(Card)
    cardApp.mount('#card-app')
  })
}
