import { defineStore } from 'pinia'
import reservationService from "@/service/reservationService.js";

export const useReservationStore = defineStore('reservation', {
  state: () => ({
    reservations: [],
    confirmedReservation: [],
    pastReservations: [],
    loading: false,
    error: null,
  }),

  getters: {
    getReservationById: (state) => (id) =>
      state.reservations.find((r) => r.idReservation === id),
  },

  actions: {
    async fetchConfirmedReservationsByUser(idUtilisateur) {
      this.loading = true
      this.error = null
      try {
        this.confirmedReservation = await reservationService.getConfirmedReservationsByUser(idUtilisateur)
        console.log(this.confirmedReservation)
      } catch (e) {
        this.error = 'Erreur lors du chargement des réservations confirmées'
      } finally {
        this.loading = false
      }
    },

    async fetchPastReservationsByUser(idUtilisateur) {
      this.loading = true
      this.error = null
      try {
        this.pastReservations = await reservationService.getPastReservationsByUser(idUtilisateur)
      } catch (e) {
        this.error = 'Erreur lors du chargement des réservations passées'
      } finally {
        this.loading = false
      }
    },

    async fetchReservationById(reservationId) {
      this.loading = true
      this.error = null
      try {
        this.currentReservation = await reservationService.getReservationById(reservationId)
      } catch (e) {
        this.error = 'Erreur lors du chargement de la réservation'
      } finally {
        this.loading = false
      }
    },

    async createReservation(idDemande, dateConfirmation, prixTotal) {
      this.loading = true
      this.error = null
      try {
        const newReservation = await reservationService.createReservation(
          idDemande, dateConfirmation, prixTotal
        )
        this.reservations.push(newReservation)
        return newReservation
      } catch (e) {
        this.error = 'Erreur lors de la création de la réservation'
      } finally {
        this.loading = false
      }
    },
async cancelReservation(reservationId) {
  this.loading = true
  this.error = null
  try {
    await reservationService.cancelReservation(reservationId)
    const r = this.confirmedReservation.find(r => r.idReservation === reservationId)
    if (r) {
      this.confirmedReservation = this.confirmedReservation.filter(r => r.idReservation !== reservationId)
      this.pastReservations.push({ ...r, statut: 'ANNULEE' })
    }
  } catch (e) {
    this.error = "Erreur lors de l'annulation"
    throw e
  } finally {
    this.loading = false
  }
},
   async updateReservationStatus(reservationId, statut) {
  this.loading = true
  this.error = null
  try {
    await reservationService.updateReservationStatus(reservationId, statut)

    const inConfirmed = this.confirmedReservation.find(r => r.idReservation === reservationId)
    const inPast = this.pastReservations.find(r => r.idReservation === reservationId)

    if (inConfirmed) {
      inConfirmed.statut = statut
      if (statut !== 'CONFIRMEE') {
        this.confirmedReservation = this.confirmedReservation.filter(r => r.idReservation !== reservationId)
        this.pastReservations.push({ ...inConfirmed, statut })
      }
    }

    if (inPast) {
      inPast.statut = statut
    }

  } catch (e) {
    this.error = 'Erreur lors de la mise à jour du statut'
  } finally {
    this.loading = false
  }
},
  },
})
