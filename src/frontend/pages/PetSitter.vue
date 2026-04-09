<template>
  <v-container class="py-10" v-if="sitter">
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card flat border class="rounded-xl pa-8">
          <div class="d-flex align-center flex-column flex-sm-row">
            <v-avatar size="120" class="mr-sm-6 mb-4 mb-sm-0">
              <v-img :src="sitter.img"></v-img>
            </v-avatar>
            <div class="text-center text-sm-left">
              <h1 class="text-h3 font-weight-black">{{ sitter.name }}</h1>
              <v-rating :model-value="sitter.rating" color="amber" density="compact" readonly half-increments></v-rating>
              <div class="text-h6 text-primary mt-2">{{ sitter.rate }} $ / nuit</div>
            </div>
          </div>

          <v-divider class="my-8"></v-divider>

          <h3 class="text-h5 font-weight-bold mb-4">À propos</h3>
         <p class="text-body-1 text-grey-darken-2">{{ sitter.description }}</p>

          <v-btn block color="primary" size="x-large" class="rounded-xl mt-10" @click="isBookingOpen = true">
            Réserver maintenant
          </v-btn>
        </v-card>
      </v-col>
    </v-row>
    <BookingModal v-model="isBookingOpen" :sitter="sitter" />
  </v-container>

  <v-container v-else class="py-10">
  <v-alert type="warning" variant="tonal" class="rounded-xl">
    Gardien introuvable.
  </v-alert>
</v-container>

</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'
import BookingModal from "@/frontend/components/BookingModal.vue"
import { petSitters } from '@/frontend/data/petSitter.js'

const route = useRoute()
const isBookingOpen = ref(false)

const sitter = computed(() => {
  const sitterId = Number(route.params.id)
  return petSitters.find((item) => item.id === sitterId) || null
})
</script>
