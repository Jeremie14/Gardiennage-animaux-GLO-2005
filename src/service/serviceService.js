import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/service'

export default {
  async createService(idGardien, typeService, description, tarif, dureeEstimee) {
    const response = await axios.post(API_URL, {
      idGardien, typeService, description, tarif, dureeEstimee,
    })
    return response.data
  },

  async getServicesBySitter(sitterId) {
    const response = await axios.get(`${API_URL}/gardien/${sitterId}`)
    return response.data
  },

  async deleteService(serviceId) {
    const response = await axios.delete(`${API_URL}/${serviceId}`)
    return response.data
  }

}
