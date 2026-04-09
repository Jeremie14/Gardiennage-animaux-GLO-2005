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
        <v-row v-if="filteredSitters.length > 0">
          <v-col v-for="sitter in filteredSitters" :key="sitter.id" cols="12" sm="6" lg="4">
            <SitterCard :sitter="sitter" @book="openBooking" />
          </v-col>
        </v-row>

        <v-alert
          v-else
          type="info"
          variant="tonal"
          class="rounded-xl"
        >
          Aucun gardien ne correspond aux filtres selectionnes.
        </v-alert>
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
import { petSitters } from '@/frontend/data/petSitter.js'

const isModalOpen = ref(false)
const selectedSitter = ref(null)

const allSitters = petSitters

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

    const matchesAnimal =
      !filters.selectedAnimal ||
      sitter.animalsAccepted.includes(filters.selectedAnimal)

    return matchesPrice && matchesServices && matchesAnimal
  })
}

</script>
