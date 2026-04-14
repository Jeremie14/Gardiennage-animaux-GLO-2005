import { defineStore } from 'pinia'
import bookingRequestService from '@/service/bookingRequestService.js'

export const useDemandeStore = defineStore('demande', {
  state: () => ({
    demandes: [],
    loading: false,
    error: null,
  }),

  actions: {
    async fetchDemandesByOwner(ownerId) {
      this.loading = true
      this.error = null
      try {
        this.demandes = await bookingRequestService.getBookingRequestsByOwner(ownerId)
      } catch (e) {
        this.error = 'Erreur lors du chargement des demandes'
      } finally {
        this.loading = false
      }
    },

    async fetchDemandesBySitter(sitterId) {
      this.loading = true
      this.error = null
      try {
        this.demandes = await bookingRequestService.getBookingRequestsBySitter(sitterId)
      } catch (e) {
        this.error = 'Erreur lors du chargement des demandes'
      } finally {
        this.loading = false
      }
    },

    async createDemande(idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, nombreHeures) {
      this.loading = true
      this.error = null
      try {
        const result = await bookingRequestService.createBookingRequest(
          idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, nombreHeures
        )
        return result
      } catch (e) {
        this.error = "Erreur lors de la création de la demande"
        throw e
      } finally {
        this.loading = false
      }
    },


    async updateStatut(requestId, statut) {
      this.loading = true
      this.error = null
      try {
        await bookingRequestService.updateBookingRequestStatus(requestId, statut)
        const d = this.demandes.find(d => d.idDemande === requestId)
        if (d) d.statutDemande = statut
      } catch (e) {
        this.error = 'Erreur lors de la mise à jour du statut'
        throw e
      } finally {
        this.loading = false
      }
    },
  },
})
