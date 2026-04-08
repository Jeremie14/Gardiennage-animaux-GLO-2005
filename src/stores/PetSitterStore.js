import { defineStore } from 'pinia'

export const usePetSitterStore = defineStore('petSitter', {
  state: () => ({
    id: null,
  })
})
