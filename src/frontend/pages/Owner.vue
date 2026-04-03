<template>
  <v-main class="bg-grey-lighten-4 min-vh-100">
    <v-container class="py-10">

      <header class="d-flex align-center justify-space-between mb-10">
        <div class="d-flex align-center">
          <v-avatar color="primary" size="64" class="mr-4 text-h5 font-weight-bold">
            SJ
          </v-avatar>
          <div>
            <h1 class="text-h4 font-weight-black text-grey-darken-4">Good morning, Sarah</h1>
            <p class="text-subtitle-1 text-grey-darken-1">
              {{ new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' }) }}
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
          <h2 class="section-title mb-0">My Pets</h2>
          <v-divider class="ml-4"></v-divider>
        </div>

        <v-row>
          <v-col v-for="pet in myPets" :key="pet.name" cols="12" sm="6" md="4">
            <AnimalCard :animal="pet" />
          </v-col>

          <v-col cols="12" sm="6" md="4">
            <v-card
              flat
              border
              class="add-pet-card rounded-xl d-flex flex-column align-center justify-center cursor-pointer bg-white"
            >
              <v-icon icon="mdi-plus" size="32" color="indigo-lighten-2"></v-icon>
              <span class="text-indigo-lighten-1 font-weight-bold mt-2">Add a pet</span>
            </v-card>
          </v-col>
        </v-row>
      </section>

      <section>
        <h2 class="section-title">Upcoming Booking</h2>
        <v-card border flat class="rounded-xl pa-6 bg-white">
          <div class="d-flex align-center">
            <v-avatar color="indigo-lighten-5" size="50" class="mr-4">
              <v-icon icon="mdi-calendar-check" color="primary"></v-icon>
            </v-avatar>
            <div>
              <p class="font-weight-bold mb-0">Next stay with Maya Kim</p>
              <p class="text-caption text-grey">April 12 - April 15</p>
            </div>
            <v-spacer></v-spacer>
            <v-btn variant="tonal" color="primary" class="rounded-lg">View Details</v-btn>
          </div>
        </v-card>
      </section>

    </v-container>
  </v-main>
</template>

<script setup>
import { ref } from 'vue'
import AnimalCard from "@/frontend/components/AnimalCard.vue";

const stats = ref([
  { label: 'My Pets', value: 2 },
  { label: 'Upcoming Stays', value: 1 },
  { label: 'Past Bookings', value: 7 }
])

const myPets = ref([
  {
    name: 'Biscuit', species: 'dog', breed: 'Golden Retriever', age: 4,
    tags: [{ text: 'Vaccinated', color: 'indigo-lighten-5' }, { text: 'Neutered', color: 'indigo-lighten-5' }]
  },
  {
    name: 'Luna', species: 'cat', breed: 'Domestic Shorthair', age: 2,
    tags: [{ text: 'Vaccinated', color: 'indigo-lighten-5' }, { text: 'Indoor only', color: 'amber-lighten-5' }]
  }
])
</script>

<style scoped>
.min-vh-100 {
  min-height: 100vh;
}

.section-title {
  color: #1a1a1a;
  font-size: 1.25rem;
  font-weight: 800;
  margin-bottom: 24px;
}

.stat-label {
  color: #757575;
  font-weight: 600;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 900;
  line-height: 1.2;
}

.add-pet-card {
  border: 2px dashed #E0E0E0 !important;
  height: 100%;
  min-height: 160px;
  transition: all 0.3s ease;
}

.add-pet-card:hover {
  border-color: #5C6BC0 !important;
  background-color: #F5F7FF !important;
}
</style>
