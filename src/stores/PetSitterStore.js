import { defineStore } from 'pinia'
import sitterService from '@/service/sitterService'

export const useSitterStore = defineStore('sitter', {
  state: () => ({
    sitters: [],
    selectedSitter: null,
    loading: false,
    error: null
  }),

  getters: {
    sitterCount: (state) => state.sitters.length,

    filterByPrice: (state) => (maxPrice) => {
      return state.sitters.filter(s => (s.tariffJournalier || s.rate || 0) <= maxPrice)
    }
  },

  actions: {

    async fetchAllSitters() {
      this.loading = true
      this.error = null
      try {
        this.sitters = await sitterService.getAllSitters();
      } catch (err) {
        this.error = "Impossible de charger la liste des gardiens."
        console.error(err)
      } finally {
        this.loading = false
      }
    },

    async fetchSitterById(id) {
      this.loading = true
      try {
        this.selectedSitter = await sitterService.getSitterById(id)
      } catch (err) {
        this.error = "Erreur lors de la récupération du profil."
        console.error(err)
      } finally {
        this.loading = false
      }
    },


   async updateSitterProfile(userId, profileUpdates) {
  this.loading = true
  try {
    // On passe directement l'objet updates au service
    const updatedData = await sitterService.updateSitter(userId, profileUpdates)
    this.selectedSitter = updatedData
    return true
  } catch (err) {
    this.error = "Échec de la mise à jour du profil."
    throw err
  } finally {
    this.loading = false
  }
}
  }
})
