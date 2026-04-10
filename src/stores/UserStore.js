import { defineStore } from 'pinia'
import userService from '@/service/userService'

export const useUserStore = defineStore('user', {
  state: () => ({
    user: JSON.parse(localStorage.getItem('user')) || null,
    loading: false,
    error: null
  }),

  getters: {
    isAuthenticated: (state) => !!state.user,
    userRole: (state) => state.user?.role || null,
    userId: (state) => state.user?.id || null
  },

  actions: {
   async login(email, password) {
  this.error = null
  try {
    const response = await userService.loginUser(email, password)
    const userData = response.data

    console.log("Données reçues du serveur:", userData)

    this.user = userData
    localStorage.setItem('user', JSON.stringify(userData))

    return true
  } catch (err) {
    this.error = "Identifiants invalides ou erreur serveur."
    throw err
  }
},

    async signup(userData) {
      try {
        const data = await userService.registerUser(
          userData.name,
          userData.lastName,
          userData.email,
          userData.password,
          userData.cellPhone,
          userData.adress,
          userData.role
        )

        return data
      } catch (err) {
        this.error = "Erreur lors de l'inscription."
        throw err
      }
    },


    logout() {
      this.user = null
      localStorage.removeItem('user')
    }
  }
})
