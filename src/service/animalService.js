import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/animal'

export default {
  async createAnimal(nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux) {
    const response = await axios.post(API_URL, {
      nom, espece, race, age, poids, idProprietaire, sexe, temperament, besoinsSpeciaux,
    })
    return response.data
  },

  async getAnimalsByOwner(ownerId) {
    const response = await axios.get(`${API_URL}/proprietaire/${ownerId}`)
    return response.data
  },

  async deleteAnimal(animalId) {
    const response = await axios.delete(`${API_URL}/${animalId}`)
    return response.data
  }
}
