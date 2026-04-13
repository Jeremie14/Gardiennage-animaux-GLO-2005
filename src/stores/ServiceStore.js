import { defineStore } from 'pinia'
import serviceService from '@/service/serviceService.js'

export const useServiceStore = defineStore('service', {
  state: () => ({
    services: [],
    loading: false,
    error: null,
  }),

  actions: {
    async fetchServicesBySitter(sitterId) {
      this.loading = true
      this.error = null
      try {
        this.services = await serviceService.getServicesBySitter(sitterId)
      } catch (e) {
        this.error = 'Erreur lors du chargement des services'
      } finally {
        this.loading = false
      }
    },

    async createService(idGardien, typeService, description, dureeEstimee) {
      this.loading = true
      this.error = null
      try {
        await serviceService.createService(idGardien, typeService, description, dureeEstimee)
        await this.fetchServicesBySitter(idGardien)
      } catch (e) {
        this.error = 'Erreur lors de la création du service'
        throw e
      } finally {
        this.loading = false
      }
    },

    async removeService(serviceId, sitterId) {
      this.loading = true
      this.error = null
      try {
        await serviceService.deleteService(serviceId)
        await this.fetchServicesBySitter(sitterId)
      } catch (e) {
        this.error = 'Erreur lors de la suppression du service'
        throw e
      } finally {
        this.loading = false
      }
    },
  },
})
