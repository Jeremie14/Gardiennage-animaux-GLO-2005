<template>
  <v-app>
    <Navbar />

    <v-main class="bg-grey-lighten-4">
      <router-view />
    </v-main>

    <v-footer border class="text-center d-flex flex-column">
      <div class="pa-4 text-grey-darken-1">
        {{ new Date().getFullYear() }} — <strong>PawStay</strong>
      </div>
    </v-footer>
  </v-app>
</template>

<script setup>
import Navbar from "@/frontend/components/NavBar.vue";
</script>
