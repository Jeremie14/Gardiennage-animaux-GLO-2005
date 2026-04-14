<script setup>
import { useUserStore } from "@/stores/UserStore.js";
import { useRouter } from 'vue-router'
import { watchEffect } from 'vue'

const userStore = useUserStore()
const router = useRouter()


const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}
</script>

<template>
  <v-app-bar flat border class="px-0">
    <v-container class="d-flex align-center pa-0">
        <v-icon icon="mdi-paw" color="primary" size="large" class="mr-2"></v-icon>
        <v-app-bar-title class="font-weight-black text-primary text-h5 ma-0">
          PawStay
        </v-app-bar-title>

      <v-spacer></v-spacer>

      <div v-if="userStore.isAuthenticated" class="hidden-sm-and-down d-flex ga-2">

    <template v-if="userStore.userRole === 'Proprietaire'">
      <v-btn variant="text" to="/">Trouver un gardien</v-btn>
      <v-btn variant="text" :to="`/owner/dashboard/${userStore.userId}`">Mes animaux</v-btn>
    </template>

    <template v-else-if="userStore.userRole === 'Gardien'">
      <v-btn variant="text" to="/sitter/bookings/">Mes demandes</v-btn>
      <v-btn variant="text" to="/sitter/profile/">Mon profil</v-btn>
    </template>
      </div>

      <div class="ml-4 d-flex ga-2">
        <template v-if="!userStore.isAuthenticated">
          <v-btn variant="text" class="text-capitalize" to="/login">Connexion</v-btn>
          <v-btn color="primary" variant="flat" class="text-capitalize rounded-lg" to="/signup">
            Inscription
          </v-btn>
        </template>

        <v-btn
          v-else
          @click="handleLogout"
          variant="tonal"
          color="error"
          class="text-capitalize rounded-lg"
        >
          Déconnexion
        </v-btn>
      </div>
    </v-container>
  </v-app-bar>
</template>
