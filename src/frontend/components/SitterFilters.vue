<template>
  <v-card border flat color="grey-lighten-2" class="pa-4 rounded-xl">
    <div class="text-subtitle-1 font-weight-bold mb-4">Filtres</div>

    <v-label>Prix maximal</v-label>
    <v-slider
      v-model="maxPrice"
      color="primary"
      thumb-label
      min="10"
      max="50"
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
const maxPrice = ref(50)

const applyFilters = () => {
  emit('apply-filters', {
    selectedServices: [],
    selectedZone: null,
    maxPrice: maxPrice.value
  })
}
</script>
