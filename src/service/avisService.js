import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/avis'

export default {
  async createReview(note, commentaire, dateAvis, idProprietaire, idGardien, idReservation) {
    const response = await axios.post(API_URL, {
      note, commentaire, dateAvis, idProprietaire, idGardien, idReservation,
    })
    return response.data
  },

  async getReviewsBySitter(sitterId) {
    const response = await axios.get(`${API_URL}/gardien/${sitterId}`)
    return response.data
  },

  async getAverageRatingBySitter(sitterId) {
    const response = await axios.get(`${API_URL}/gardien/${sitterId}/moyenne`)
    return response.data
  }
}
