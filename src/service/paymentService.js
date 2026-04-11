import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/paiement'

export default {
  async createPayment(montant, datePaiement, methodePaiement, idReservation, statutPaiement = 'EN_ATTENTE') {
    const response = await axios.post(API_URL, {
      montant, datePaiement, methodePaiement, idReservation, statutPaiement,
    })
    return response.data
  },

  async getPaymentByReservation(reservationId) {
    const response = await axios.get(`${API_URL}/reservation/${reservationId}`)
    return response.data
  },

  async updatePaymentStatus(paymentId, statut) {
    const response = await axios.put(`${API_URL}/${paymentId}/statut`, { statut })
    return response.data
  }
}
