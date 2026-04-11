import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/animal'

export default {
  async createAnimal(name, species, race, age, weight, idProprietaire, sexe, temper, specialNeeds) {
    const response = await axios.post(API_URL, {
      name, species, race, age, weight, idProprietaire, sexe, temper, specialNeeds,
    })
    return response.data
  },

  async getAnimalsByOwner(ownerId) {
    const response = await axios.get(`${API_URL}/proprietaire/${ownerId}`)
    return response.data
  },

  async getAnimalById(animalId) {
    const response = await axios.get(`${API_URL}/${animalId}`)
    return response.data
  },

  async deleteAnimal(animalId) {
    const response = await axios.delete(`${API_URL}/${animalId}`)
    return response.data
  },

  async updateAnimalPic(animalId, picture){
    const response = await axios.put(`${API_URL}/${animalId}`, {picture})
    return response.data
  }
}
