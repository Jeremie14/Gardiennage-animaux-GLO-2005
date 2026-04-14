import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/reservation'

export default {
  async createReservation(idDemande, dateConfirmation, prixTotal, statutReservation = 'CONFIRMEE') {
    const response = await axios.post(API_URL, {
      idDemande, dateConfirmation, prixTotal, statutReservation,
    })
    return response.data
  },

  async getReservationById(reservationId) {
    const response = await axios.get(`${API_URL}/${reservationId}`)
    return response.data
  },

  async getConfirmedReservationsByUser(idUtilisateur) {
  const response = await axios.get(`${API_URL}/${idUtilisateur}/confirmee`)
  return response.data
},

  async getPastReservationsByUser(idUtilisateur) {
  const response = await axios.get(`${API_URL}/${idUtilisateur}/passees`)
  return response.data
},
async cancelReservation(reservationId) {
  const response = await axios.put(`${API_URL}/${reservationId}/statut`, { statut: 'ANNULEE' })
  return response.data
},
  async updateReservationStatus(reservationId, statut) {
    const response = await axios.put(`${API_URL}/${reservationId}/statut`, { statut })
    return response.data
  }

}
