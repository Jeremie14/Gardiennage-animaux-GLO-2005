import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/disponibilite'

export default {
  async createAvailability(idGardien, dateDebut, dateFin, statutDisponibilite = 'DISPONIBLE') {
    const response = await axios.post(API_URL, {
      idGardien, dateDebut, dateFin, statutDisponibilite,
    })
    return response.data
  },

  async getAvailabilitiesBySitter(sitterId) {
    const response = await axios.get(`${API_URL}/gardien/${sitterId}`)
    return response.data
  },

  async updateAvailabilityStatus(availabilityId, statut) {
    const response = await axios.put(`${API_URL}/${availabilityId}`, { statut })
    return response.data
  }
}
