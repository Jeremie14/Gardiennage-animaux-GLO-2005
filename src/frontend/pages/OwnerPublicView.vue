<template>
  <v-container class="py-10 text-center">
    <v-avatar size="120" color="primary" class="mb-4">{{ userInitials }}</v-avatar>
    <h1 class="text-h4 font-weight-bold">{{ fullName }}</h1>
    <p class="text-grey">Membre depuis {{ memberSince }} • 📍 {{ location }}</p>

    <v-divider class="my-10"></v-divider>

    <v-progress-linear v-if="animalStore.loading" indeterminate color="primary" class="mb-4"></v-progress-linear>

    <h2 class="text-h5 font-weight-bold mb-6 text-left">Les animaux de {{ userStore.user?.prenom }}</h2>

    <v-row>
      <v-col v-for="pet in animalStore.animals" :key="pet.idAnimal" cols="12" sm="4">
        <v-card border flat class="rounded-xl pa-4">
          <v-avatar size="80" class="mb-2">{{ speciesEmoji(pet.espece) }}</v-avatar>
          <div class="font-weight-black text-h6">{{ pet.name }}</div>
          <div class="text-body-2 text-grey">{{ pet.race }}</div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/UserStore.js'
import { useAnimalStore } from '@/stores/AnimalStore.js'

const userStore = useUserStore()
const animalStore = useAnimalStore()

const userInitials = computed(() => {
  const p = userStore.user?.name?.[0] ?? ''
  const n = userStore.user?.nom?.[0] ?? ''
  return (p + n).toUpperCase()
})

const fullName = computed(() => `${userStore.user?.name ?? ''} ${userStore.user?.lastName?.[0] ?? ''}.`)

const memberSince = computed(() => {
  const date = userStore.user?.dateInscription
  return date ? new Date(date).getFullYear() : '—'
})

const location = computed(() => userStore.user?.adress ?? '—')

const speciesEmoji = (species) => {
  const map = { chien: '🐕', chat: '🐈', lapin: '🐇', oiseau: '🐦', furet: '🦡', hamster: '🐹' }
  return map[species?.toLowerCase()] ?? '🐾'
}

onMounted(() => {
  if (userStore.userId) {
    animalStore.fetchAnimals(userStore.userId)
  }
})
</script>
