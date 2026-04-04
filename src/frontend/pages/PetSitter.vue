<template>
  <v-container class="py-8">
    <v-row>
      <v-col cols="12" md="8">
        <v-card flat border color="grey-lighten-3" class="rounded-xl pa-6">
          <div class="d-flex align-center mb-4">
            <v-avatar size="80" class="mr-4">
              <v-img src="https://i.pravatar.cc/150?u=1"></v-img>
            </v-avatar>
            <div>
              <h1 class="text-h4">Sarah J.</h1>
              <v-chip color="amber" variant="flat" size="small" class="mt-1">
                ★ 4.9 (120 reviews)
              </v-chip>
            </div>
          </div>

          <v-divider class="my-4"></v-divider>

          <h2 class="text-h6 mb-2">A propos de moi</h2>
          <p class="text-body-1 text-grey-darken-2">
            Gardienne professionnelle avec plus de 5 ans d'experience. Je me specialise dans les chiens ages et les chats anxieux. Je suis certifiee en premiers soins pour animaux et j'etudie actuellement en medecine veterinaire.
          </p>

          <h2 class="text-h6 mt-6 mb-3">Services offerts</h2>
          <v-chip-group>
            <v-chip variant="outlined" color="primary">Promenade</v-chip>
            <v-chip variant="outlined" color="primary">Garde a domicile</v-chip>
            <v-chip variant="outlined" color="primary">Garde de nuit</v-chip>
          </v-chip-group>
        </v-card>
      </v-col>

      <v-col cols="12" md="4">
        <v-card flat border color="grey-lighten-3" class="rounded-xl pa-6 sticky-card">
          <h2 class="text-h5 font-weight-bold mb-4">$45 / nuit</h2>
          <v-btn block color="primary" size="x-large" class="rounded-lg mb-4" @click="isBookingOpen = true"> Reserver ce gardien </v-btn>
          <div class="text-caption text-center text-grey">
            Aucun paiement ne sera preleve pour le moment
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
  <BookingModal v-model="isBookingOpen" :sitter="sitter" />
</template>

<script setup>
import { ref } from 'vue'
import BookingModal from '@/frontend/components/BookingModal.vue'

const isBookingOpen = ref(false)

const sitter = {
  id: 1,
  name: 'Sarah J.'
}
</script>

<style scoped>
.sticky-card {
  position: sticky;
  top: 90px;
}
</style>
