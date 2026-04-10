<template>
  <v-main class="bg-grey-lighten-4 min-vh-100">
    <v-container class="py-10">

      <header class="d-flex align-center justify-space-between mb-10">
        <div class="d-flex align-center">
          <v-avatar color="primary" size="64" class="mr-4 text-h5 font-weight-bold">
            {{ userInitials }}
          </v-avatar>
          <div>
            <h1 class="text-h4 font-weight-black text-grey-darken-4">Bonjour, {{ userStore.user?.name }}</h1>
            <p class="text-subtitle-1 text-grey-darken-1">
              {{ new Date().toLocaleDateString('fr-CA', { weekday: 'long', month: 'long', day: 'numeric' }) }}
            </p>
          </div>
        </div>

        <v-btn icon variant="outlined" color="grey-lighten-1" class="rounded-lg bg-white">
          <v-badge dot color="error">
            <v-icon icon="mdi-bell-outline" color="grey-darken-2"></v-icon>
          </v-badge>
        </v-btn>
      </header>

      <v-row class="mb-12">
        <v-col cols="4" md="2" v-for="stat in stats" :key="stat.label">
          <div class="stat-label">{{ stat.label }}</div>
          <div class="stat-value text-indigo-600">{{ stat.value }}</div>
        </v-col>
      </v-row>

      <section class="mb-12">
        <div class="d-flex align-center mb-6">
          <h2 class="section-title mb-0">Mes animaux</h2>
          <v-divider class="ml-4"></v-divider>
        </div>

        <v-progress-linear v-if="animalStore.loading" indeterminate color="primary" class="mb-4"></v-progress-linear>

        <v-alert v-if="animalStore.error" type="error" variant="tonal" class="mb-4">
          {{ animalStore.error }}
        </v-alert>

        <v-row>
          <v-col v-for="pet in animalStore.animals" :key="pet.idAnimal" cols="12" sm="6" md="4">
            <AnimalCard :animal="pet" @delete="handleDeleteAnimal(pet.idAnimal)" />
          </v-col>

          <v-col cols="12" sm="6" md="4">
            <v-card
              flat border
              class="add-pet-card rounded-xl d-flex flex-column align-center justify-center cursor-pointer bg-white"
              @click="openAddDialog"
            >
              <v-icon icon="mdi-plus" size="32" color="indigo-lighten-2"></v-icon>
              <span class="text-indigo-lighten-1 font-weight-bold mt-2">Ajouter un animal</span>
            </v-card>
          </v-col>
        </v-row>
      </section>

      <section>
        <h2 class="section-title">Reservation a venir</h2>
        <v-card border flat class="rounded-xl pa-6 bg-white">
          <div class="d-flex align-center">
            <v-avatar color="indigo-lighten-5" size="50" class="mr-4">
              <v-icon icon="mdi-calendar-check" color="primary"></v-icon>
            </v-avatar>
            <div>
              <p class="font-weight-bold mb-0">Prochaine garde avec Maya Kim</p>
              <p class="text-caption text-grey">April 12 - April 15</p>
            </div>
            <v-spacer></v-spacer>
            <v-btn variant="tonal" color="primary" class="rounded-lg">Voir les details</v-btn>
          </div>
        </v-card>
      </section>

    </v-container>

    <v-dialog v-model="addDialog" max-width="500">
      <v-card class="pa-6 rounded-xl">
        <h3 class="text-h6 font-weight-black mb-4">Ajouter un animal</h3>

        <v-text-field v-model="newAnimal.name" label="Nom" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-text-field v-model="newAnimal.species" label="Espèce" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-text-field v-model="newAnimal.race" label="Race" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-text-field v-model="newAnimal.age" label="Âge" type="number" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-text-field v-model="newAnimal.weight" label="Poids (kg)" type="number" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-select v-model="newAnimal.sexe" label="Sexe" :items="['Mâle', 'Femelle']" variant="outlined" density="comfortable" class="mb-2"></v-select>
        <v-text-field v-model="newAnimal.temper" label="Tempérament" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
        <v-text-field v-model="newAnimal.sepcialNeeds" label="Besoins spéciaux" variant="outlined" density="comfortable" class="mb-4"></v-text-field>

        <div class="d-flex justify-end ga-2">
          <v-btn variant="text" @click="addDialog = false">Annuler</v-btn>
          <v-btn color="primary" :loading="animalStore.loading" @click="handleAddAnimal">Ajouter</v-btn>
        </div>
      </v-card>
    </v-dialog>

  </v-main>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import AnimalCard from '@/frontend/components/AnimalCard.vue'
import { useUserStore } from '@/stores/UserStore.js'
import { useAnimalStore } from '@/stores/AnimalStore.js'

const userStore = useUserStore()
const animalStore = useAnimalStore()

const addDialog = ref(false)
const newAnimal = ref({
  name: '', speices: '', race: '', age: null, wweight: null,
  sexe: null, temper: '', specialNeeds: ''
})

const userInitials = computed(() => {
  const p = userStore.user?.name?.[0] ?? ''
  const n = userStore.user?.lastName?.[0] ?? ''
  return (p + n).toUpperCase()
})

const stats = computed(() => [
  { label: 'Mes animaux', value: animalStore.animalCount },
  { label: 'Gardes a venir', value: 1 },
  { label: 'Reservations passees', value: 7 },
])

onMounted(() => {
  if (userStore.userId) {
    animalStore.fetchAnimals(userStore.userId)
  }
})

const openAddDialog = () => {
  newAnimal.value = { name: '', species: '', race: '', age: null, weight: null, sexe: null, temper: '', specialNeeds: '' }
  addDialog.value = true
}

const handleAddAnimal = async () => {
  await animalStore.addAnimal({
    ...newAnimal.value,
    idProprietaire: userStore.userId,
  })
  addDialog.value = false
}

const handleDeleteAnimal = async (animalId) => {
  await animalStore.removeAnimal(animalId, userStore.userId)
}
</script>

<style scoped>
.min-vh-100 { min-height: 100vh; }
.section-title { color: #1a1a1a; font-size: 1.25rem; font-weight: 800; margin-bottom: 24px; }
.stat-label { color: #757575; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
.stat-value { font-size: 2.5rem; font-weight: 900; line-height: 1.2; }
.add-pet-card { border: 2px dashed #E0E0E0 !important; height: 100%; min-height: 160px; transition: all 0.3s ease; }
.add-pet-card:hover { border-color: #5C6BC0 !important; background-color: #F5F7FF !important; }
</style>
