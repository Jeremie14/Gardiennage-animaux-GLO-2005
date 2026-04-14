<template>
  <v-container>

    <section class="my-8">
      <h2 class="text-h4 font-weight-black mb-2">Top 5 gardiens</h2>
      <p class="text-grey-darken-1 mb-6">Les gardiens les mieux notés par notre communauté</p>

      <v-row v-if="sitterStore.loading">
        <v-col v-for="n in 5" :key="n" cols="12" sm="6" md="4" lg="2">
          <v-skeleton-loader type="card" class="rounded-xl"></v-skeleton-loader>
        </v-col>
      </v-row>

      <v-row v-else-if="sitterStore.topSitters.length === 0">
        <v-col cols="12">
          <v-alert type="info" variant="tonal" class="rounded-xl">
            Pas encore assez d'avis pour afficher un classement.
          </v-alert>
        </v-col>
      </v-row>

      <v-row v-else>
        <v-col v-for="(sitter, index) in sitterStore.topSitters" :key="sitter.id" cols="12" sm="6" md="4" lg="2">
          <v-card flat border class="rounded-xl pa-5 text-center h-100 top-card" :to="`/sitter/${sitter.id}`">
            <div class="rank-badge mb-2">
              <v-chip :color="index === 0 ? 'amber-darken-2' : index === 1 ? 'grey' : 'brown'" variant="flat" size="small">
                #{{ index + 1 }}
              </v-chip>
            </div>
            <v-avatar size="72" class="mb-3">
              <v-img v-if="sitter.photo" :src="sitter.photo" cover></v-img>
              <v-icon v-else icon="mdi-account" size="40" color="grey"></v-icon>
            </v-avatar>
            <p class="font-weight-black mb-0">{{ sitter.name }} {{ sitter.lastName }}</p>
            <p class="text-caption text-grey mb-2">{{ sitter.priceHour }} $ / h</p>
            <v-chip color="amber-darken-2" variant="flat" size="small" class="mb-1">
              <v-icon icon="mdi-star" start size="12"></v-icon>
              {{ sitter.noteMoyenne }} / 100
            </v-chip>
            <p class="text-caption text-grey mt-1">{{ sitter.nbAvis }} avis</p>
          </v-card>
        </v-col>
      </v-row>
    </section>

    <v-divider class="mb-8"></v-divider>

    <div class="d-flex justify-space-between align-center mb-6">
      <h1 class="text-h4 font-weight-black">Trouver un gardien</h1>
      <div class="d-flex ga-3 align-center">
        <v-chip variant="outlined" color="primary">
          {{ filteredSitters.length }} gardiens trouvés
        </v-chip>
        <v-btn color="primary" variant="tonal" class="rounded-lg" @click="filterDialog = true">
          <v-icon icon="mdi-filter-outline" start></v-icon>
          Filtres
        </v-btn>
      </div>
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
          variant="tonal" class="rounded-xl"
        >
          {{ sitterStore.error || 'Aucun gardien ne correspond à vos critères de recherche.' }}
        </v-alert>
      </v-col>
    </v-row>

    <BookingModal v-model="isModalOpen" :sitter="selectedSitter" />

    <v-dialog v-model="filterDialog" max-width="420">
      <v-card class="rounded-xl pa-2">
        <v-card-title class="text-h6 font-weight-black pa-4 pb-2">Filtres</v-card-title>
        <v-card-text>
          <SitterFilters @apply-filters="handleApplyFilters" />
        </v-card-text>
      </v-card>
    </v-dialog>

  </v-container>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import SitterFilters from "@/frontend/components/SitterFilters.vue"
import SitterCard from '@/frontend/components/SitterCard.vue'
import BookingModal from '@/frontend/components/BookingModal.vue'
import { useSitterStore } from "@/stores/PetSitterStore.js"

const sitterStore = useSitterStore()

const isModalOpen = ref(false)
const selectedSitter = ref(null)
const filteredSitters = ref([])
const filterDialog = ref(false)

onMounted(async () => {
  await sitterStore.fetchAllSitters()
  await sitterStore.fetchTopSitters()
  filteredSitters.value = sitterStore.sitters
})

watch(() => sitterStore.sitters, (newSitters) => {
  filteredSitters.value = newSitters
})

const openBooking = (sitter) => {
  selectedSitter.value = sitter
  isModalOpen.value = true
}

const handleApplyFilters = (filters) => {
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
  filterDialog.value = false
}
</script>

<style scoped>
.top-card {
  transition: transform 0.2s ease;
  cursor: pointer;
}
.top-card:hover {
  transform: translateY(-4px);
}
</style>
