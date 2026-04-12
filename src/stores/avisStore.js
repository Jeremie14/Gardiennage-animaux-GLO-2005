import { defineStore } from 'pinia'
import avisService from '@/service/avisService.js'

export const useAvisStore = defineStore('avis', {
  state: () => ({
    avis: [],
    moyenne: null,
    loading: false,
    error: null,
  }),

  actions: {
    async fetchAvisBySitter(sitterId) {
      this.loading = true
      this.error = null
      try {
        this.avis = await avisService.getReviewsBySitter(sitterId)
      } catch (e) {
        this.error = 'Erreur lors du chargement des avis'
      } finally {
        this.loading = false
      }
    },

    async fetchMoyenneBySitter(sitterId) {
      this.loading = true
      this.error = null
      try {
        const data = await avisService.getAverageRatingBySitter(sitterId)
        this.moyenne = data.moyenneNote
      } catch (e) {
        this.error = 'Erreur lors du chargement de la moyenne'
      } finally {
        this.loading = false
      }
    },

    async createAvis(note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) {
      this.loading = true
      this.error = null
      try {
        await avisService.createReview(note, commentaire, dateAvis, idProprietaire, idGardien, idReservation)
      } catch (e) {
        this.error = "Erreur lors de l'envoi de l'avis"
        throw e
      } finally {
        this.loading = false
      }
    },
  },
})
