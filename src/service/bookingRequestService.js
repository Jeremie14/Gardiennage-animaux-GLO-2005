import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/demande'

export default {
  async createBookingRequest(idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, nombreHeures) {
    const response = await axios.post(API_URL, {
      idProprietaire, idGardien, idAnimal, idService, dateDebut, dateFin, message, nombreHeures,
    })
    return response.data
  },


  async getBookingRequestsByOwner(ownerId) {
    const response = await axios.get(`${API_URL}/proprietaire/${ownerId}`)
    return response.data
  },

  async getBookingRequestsBySitter(sitterId) {
    const response = await axios.get(`${API_URL}/gardien/${sitterId}`)
    return response.data
  },


  async updateBookingRequestStatus(requestId, statut) {
    const response = await axios.put(`${API_URL}/${requestId}/statut`, { statut })
    return response.data
  }
}
