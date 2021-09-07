import { createApp } from 'vue'
import Game from '@/components/Game.vue'
import Card from '@/components/Card.vue'

export default {
  game: () => {
    document.addEventListener('DOMContentLoaded', () => {
      createApp(Game).mount('#game-vue')
    })
  },
  card: () => {
    document.addEventListener('DOMContentLoaded', () => {
      createApp(Card).mount('#card-vue')
    })
  }
}
