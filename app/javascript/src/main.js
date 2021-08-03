import { createApp } from 'vue'
import Game from '@/components/Game.vue'

export default () => {
  document.addEventListener('DOMContentLoaded', () => {
    const gameApp = createApp(Game)
    gameApp.mount('#game-app')
  })
}
