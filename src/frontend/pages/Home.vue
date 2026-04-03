<template>
  <v-container>
    <v-row>

      <v-col cols="12" md="3">
        <SitterFilters />
      </v-col>

      <v-col cols="12" md="9">
        <div class="d-flex justify-space-between align-center mb-6">
          <h1 class="text-h4 font-weight-black">Find a Sitter</h1>
          <v-chip variant="outlined" color="primary">
            {{ sitters.length }} sitters found
          </v-chip>
        </div>

        <v-row>
          <v-col v-for="sitter in sitters" :key="sitter.id" cols="12" sm="6" lg="4">
            <SitterCard :sitter="sitter" @book="openBooking" />
          </v-col>
        </v-row>
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

const isModalOpen = ref(false)
const selectedSitter = ref(null)

const sitters = ref([
  { id: 1, name: 'Sarah J.', rate: 45, rating: 4.9, bio: 'Senior dog specialist.', img: 'https://i.pravatar.cc/150?u=1' },
  { id: 2, name: 'Mike R.', rate: 30, rating: 4.7, bio: 'Active park walker.', img: 'https://i.pravatar.cc/150?u=2' },
  { id: 3, name: 'Elena W.', rate: 55, rating: 5.0, bio: 'Vet student.', img: 'https://i.pravatar.cc/150?u=3' },

])

const openBooking = (sitter) => {
  selectedSitter.value = sitter
  isModalOpen.value = true
}
</script>
