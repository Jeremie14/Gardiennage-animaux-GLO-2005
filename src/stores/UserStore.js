import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const role = ref(null)
  const isAuthenticated = ref(false)


  function login(userRole) {
    role.value = userRole
    isAuthenticated.value = true
  }

  function logout() {
    role.value = null
    isAuthenticated.value = false
  }

  return { role, isAuthenticated, login, logout }
})
