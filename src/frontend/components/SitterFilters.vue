<template>
  <v-card border flat color="grey-lighten-2" class="pa-4 rounded-xl">
    <div class="text-subtitle-1 font-weight-bold mb-4">Filtres</div>

    <v-label class="mb-2">Services</v-label>
    <v-checkbox
      v-model="selectedServices"
      label="Promenade"
      value="Promenade"
      density="compact"
      hide-details
      color="primary"
    ></v-checkbox>
    <v-checkbox
      v-model="selectedServices"
      label="Garde a domicile"
      value="Garde a domicile"
      density="compact"
      hide-details
      color="primary"
    ></v-checkbox>
    <v-checkbox
      v-model="selectedServices"
      label="Visites ponctuelles"
      value="Visites ponctuelles"
      density="compact"
      hide-details
      color="primary"
    ></v-checkbox>

    <v-divider class="my-4"></v-divider>

    <v-label>Prix maximal</v-label>
    <v-slider
      v-model="maxPrice"
      color="primary"
      thumb-label
      min="10"
      max="150"
      step="5"
    ></v-slider>

    <v-btn block color="primary" class="mt-4 rounded-lg" @click="applyFilters">
      Appliquer
    </v-btn>
  </v-card>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['apply-filters'])
const selectedServices = ref([])
const maxPrice = ref(150)

const applyFilters = () => {
  emit('apply-filters', {
    selectedServices: selectedServices.value,
    maxPrice: maxPrice.value
  })
}
</script>
