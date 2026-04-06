<template>
  <v-container class="py-10 text-center">
    <v-avatar size="120" color="primary" class="mb-4">SJ</v-avatar>
    <h1 class="text-h4 font-weight-bold">Sarah J.</h1>
    <p class="text-grey">Membre depuis 2023 • 📍 Montréal</p>

    <v-divider class="my-10"></v-divider>

    <h2 class="text-h5 font-weight-bold mb-6 text-left">Les animaux de Sarah</h2>
    <v-row>
      <v-col v-for="pet in publicPets" :key="pet.id" cols="12" sm="4">
        <v-card border flat class="rounded-xl pa-4">
          <v-avatar size="80" class="mb-2">🐕</v-avatar>
          <div class="font-weight-black text-h6">{{ pet.name }}</div>
          <div class="text-body-2 text-grey">{{ pet.breed }}</div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
const publicPets = [{ id: 1, name: 'Biscuit', breed: 'Golden Retriever' }]
</script>
