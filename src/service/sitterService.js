import axios from 'axios'

const API_URL = 'http://127.0.0.1:5000/gardien'

export default {
  async getAllSitters() {
    const response = await axios.get(API_URL)
    const sitters = response.data.data || response.data

    return sitters.map((sitter) => ({
      id: sitter.id,
      name: sitter.name,
      lastName: sitter.latName,
      priceHour: sitter.priceHour,
      description: sitter.description,
      photo: sitter.photo,
      rating: sitter.moyenneNote,
      zoneService: sitter.zoneService,
      experience: sitter.experience,
      email: sitter.email,
      adress: sitter.adress,
      services: ['Promenade', 'Garde a domicile', 'Visites ponctuelles']
    }))
    },

async getSitterById(userId) {
  const response = await axios.get(`${API_URL}/${userId}`)
  const sitter = response.data.data || response.data

  return {
    id: sitter.id,
    name: sitter.name,
    lastName: sitter.latName,
    priceHour: sitter.priceHour,
    description: sitter.description,
    photo: sitter.photo,
    rating: 5.0,
    zoneService: sitter.zoneService,
    experience: sitter.experience,
     email: sitter.email,
    adress: sitter.adress,
    services: ['Promenade', 'Garde a domicile', 'Visites ponctuelles']
  }
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
