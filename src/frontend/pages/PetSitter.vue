<template>
  <v-container class="py-8">
    <v-row v-if="sitter">
      <v-col cols="12" md="8">
        <v-card flat border color="grey-lighten-3" class="rounded-xl pa-6">
          <div class="d-flex align-center mb-4">
            <v-avatar size="80" class="mr-4">
              <v-img :src="sitter.img"></v-img>
            </v-avatar>
            <div>
              <h1 class="text-h4">{{ sitter.name }}</h1>
              <v-chip color="amber" variant="flat" size="small" class="mt-1">
                ★ {{ sitter.rating }}
              </v-chip>
            </div>
          </div>

          <v-divider class="my-4"></v-divider>

          <h2 class="text-h6 mb-2">A propos de moi</h2>
          <p class="text-body-1 text-grey-darken-2">
            {{ sitter.description }}
          </p>

          <h2 class="text-h6 mt-6 mb-3">Services offerts</h2>
          <v-chip-group>
            <v-chip
              v-for="service in sitter.services"
              :key="service"
              variant="outlined"
              color="primary"
            >
              {{ service }}
            </v-chip>
          </v-chip-group>
        </v-card>
      </v-col>

      <v-col cols="12" md="4">
        <v-card flat border color="grey-lighten-3" class="rounded-xl pa-6 sticky-card">
          <h2 class="text-h5 font-weight-bold mb-4">${{ sitter.rate }} / nuit</h2>
          <v-btn
            block
            color="primary"
            size="x-large"
            class="rounded-lg mb-4"
            @click="isBookingOpen = true"
          >
            Reserver ce gardien
          </v-btn>
          <div class="text-caption text-center text-grey">
            Aucun paiement ne sera preleve pour le moment
          </div>
        </v-card>
      </v-col>
    </v-row>

    <v-alert v-else type="warning" variant="tonal">
      Gardien introuvable.
    </v-alert>

    <BookingModal v-model="isBookingOpen" :sitter="sitter" />
  </v-container>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import BookingModal from '@/frontend/components/BookingModal.vue'

const route = useRoute()
const isBookingOpen = ref(false)

const sitters = [
  {
    id: 1,
    name: 'Sarah J.',
    rate: 45,
    rating: 4.9,
    img: 'https://i.pravatar.cc/150?u=1',
    description: "Specialiste des chiens ages et des chats anxieux.",
    services: ['Promenade', 'Garde a domicile']
  },
  {
    id: 2,
    name: 'Mike R.',
    rate: 30,
    rating: 4.7,
    img: 'https://i.pravatar.cc/150?u=2',
    description: "Gardien energique, ideal pour les animaux actifs et les visites ponctuelles.",
    services: ['Promenade', 'Visites ponctuelles']
  },
  {
    id: 3,
    name: 'Elena W.',
    rate: 55,
    rating: 5.0,
    img: 'https://i.pravatar.cc/150?u=3',
    description: "Etudiante en medecine veterinaire offrant une garde attentive et rassurante.",
    services: ['Garde a domicile', 'Visites ponctuelles']
  }
]

const sitter = computed(() => {
  const sitterId = Number(route.params.id)
  return sitters.find((item) => item.id === sitterId) || null
})
</script>

<style scoped>
.sticky-card {
  position: sticky;
  top: 90px;
}
</style>
