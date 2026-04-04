<template>
  <v-container>
    <v-row>

      <v-col cols="12" md="3">
        <SitterFilters @apply-filters="applyFilters" />
      </v-col>

      <v-col cols="12" md="9">
        <div class="d-flex justify-space-between align-center mb-6">
          <h1 class="text-h4 font-weight-black">Trouver un gardien</h1>
          <v-chip variant="outlined" color="primary">
            {{ filteredSitters.length }} gardiens trouves
          </v-chip>
        </div>

        <v-row>
          <v-col v-for="sitter in filteredSitters" :key="sitter.id" cols="12" sm="6" lg="4">
            <SitterCard :sitter="sitter" @book="openBooking" />
          </v-col>
        </v-row>
      </v-col>
    </v-row>

    <BookingModal v-model="isModalOpen" :sitter="selectedSitter" />
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import SitterFilters from "@/frontend/components/SitterFilters.vue";
import SitterCard from '@/frontend/components/SitterCard.vue'
import BookingModal from '@/frontend/components/BookingModal.vue'

const isModalOpen = ref(false)
const selectedSitter = ref(null)

const allSitters = [
  {
    id: 1,
    name: 'Sarah J.',
    rate: 45,
    rating: 4.9,
    bio: 'Specialiste des chiens ages.',
    img: 'https://i.pravatar.cc/150?u=1',
    services: ['Promenade', 'Garde a domicile']
  },
  {
    id: 2,
    name: 'Mike R.',
    rate: 30,
    rating: 4.7,
    bio: 'Promeneur energique et fiable.',
    img: 'https://i.pravatar.cc/150?u=2',
    services: ['Promenade', 'Visites ponctuelles']
  },
  {
    id: 3,
    name: 'Elena W.',
    rate: 55,
    rating: 5.0,
    bio: 'Etudiante en medecine veterinaire.',
    img: 'https://i.pravatar.cc/150?u=3',
    services: ['Garde a domicile', 'Visites ponctuelles']
  },
]

const filteredSitters = ref([...allSitters])

const openBooking = (sitter) => {
  selectedSitter.value = sitter
  isModalOpen.value = true
}

const applyFilters = (filters) => {
  filteredSitters.value = allSitters.filter((sitter) => {
    const matchesPrice = sitter.rate <= filters.maxPrice
    const matchesServices =
      !filters.selectedServices.length ||
      filters.selectedServices.every((service) => sitter.services.includes(service))

    return matchesPrice && matchesServices
  })
}

</script>
