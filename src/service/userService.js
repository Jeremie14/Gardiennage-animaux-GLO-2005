import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/user'

export default {
  async registerUser(name, lastName, email, password, cellPhone, adress, role = 'Proprietaire') {
    const response = await axios.post(`${API_URL}/register`, {
      name, lastName, email, password, cellPhone, adress, role,
    })
    return response.data
  },

  async loginUser(email, password) {
    return await axios.post(`${API_URL}/login`, { email, password })
  },

  async getUserById(userId) {
    const response = await axios.get(`${API_URL}/${userId}`)
    return response.data
  },

  async updateUser(userId, name, lastName, email, cellPhone, adress) {
    const response = await axios.put(`${API_URL}/${userId}`, {
      name, lastName, email, cellPhone, adress,
    })
    return response.data
  },

  async deleteUser(userId) {
    const response = await axios.delete(`${API_URL}/${userId}`)
    return response.data
  }
}
