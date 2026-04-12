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
            {{ filteredSitters.length }} gardiens trouvés
          </v-chip>
        </div>

        <v-row v-if="sitterStore.loading">
          <v-col v-for="n in 3" :key="n" cols="12" sm="6" lg="4">
            <v-skeleton-loader type="card" class="rounded-xl"></v-skeleton-loader>
          </v-col>
        </v-row>

        <v-row v-else>
          <v-col v-for="sitter in filteredSitters" :key="sitter.id" cols="12" sm="6" lg="4">
            <SitterCard :sitter="sitter" @book="openBooking" />
          </v-col>

          <v-col cols="12" v-if="filteredSitters.length === 0">
            <v-alert
              :type="sitterStore.error ? 'error' : 'info'"
              variant="tonal"
              class="rounded-xl"
            >
              {{ sitterStore.error || 'Aucun gardien ne correspond à vos critères de recherche.' }}
            </v-alert>
          </v-col>
        </v-row>
      </v-col>
    </v-row>

    <BookingModal v-model="isModalOpen" :sitter="selectedSitter" />
  </v-container>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import SitterFilters from "@/frontend/components/SitterFilters.vue"
import SitterCard from '@/frontend/components/SitterCard.vue'
import BookingModal from '@/frontend/components/BookingModal.vue'
import {useSitterStore} from "@/stores/PetSitterStore.js";

const sitterStore = useSitterStore()

const isModalOpen = ref(false)
const selectedSitter = ref(null)

const filteredSitters = ref([])

onMounted(async () => {
  await sitterStore.fetchAllSitters()
  filteredSitters.value = sitterStore.sitters
})

watch(() => sitterStore.sitters, (newSitters) => {
  filteredSitters.value = newSitters
})

const openBooking = (sitter) => {
  selectedSitter.value = sitter
  isModalOpen.value = true
}

const applyFilters = (filters) => {
  filteredSitters.value = sitterStore.sitters.filter((sitter) => {
    const sitterPrice = sitter.priceHour || sitter.tariffJournalier || sitter.rate || 0
    const matchesPrice = sitterPrice <= filters.maxPrice

    const sitterServices = sitter.services || []
    const matchesServices =
      !filters.selectedServices.length ||
      filters.selectedServices.every((s) => sitterServices.includes(s))

    const matchesZone =
      !filters.selectedZone ||
      sitter.zoneService === filters.selectedZone

    return matchesPrice && matchesServices && matchesZone
  })
}
</script>
