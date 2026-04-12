import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/gardien'

export default {
 async getAllSitters() {
    const response = await axios.get(API_URL)
    // On essaie de récupérer .data.data (standard API), sinon .data (tableau direct)
    return response.data.data || response.data
  },

  async getSitterById(userId) {
    const response = await axios.get(`${API_URL}/${userId}`)
    return response.data.data || response.data
  },

  async createSitter(sitterData) {
    const response = await axios.post(API_URL, sitterData)
    return response.data.data
  },



  async updateSitter(userId, updates) {
    const response = await axios.put(`${API_URL}/${userId}`, updates)
    return response.data.data
  }
}
