<template>
  <v-container class="py-10">
    <v-row v-if="sitterStore.loading" justify="center" class="py-10">
      <v-progress-circular indeterminate color="primary" size="64"></v-progress-circular>
    </v-row>

    <v-row v-else-if="sitterStore.selectedSitter" justify="center">
      <v-col cols="12" md="8">
        <v-card flat border class="rounded-xl pa-8">
          <div class="d-flex align-center flex-column flex-sm-row">
            <v-avatar size="120" class="mr-sm-6 mb-4 mb-sm-0 shadow-lg">
              <v-img :src="sitterStore.selectedSitter.img || 'https://i.pravatar.cc/150'"></v-img>
            </v-avatar>
            <div class="text-center text-sm-left">
              <h1 class="text-h3 font-weight-black">
                {{ sitterStore.selectedSitter.name || sitterStore.selectedSitter.lastName }}
              </h1>
              <v-rating
                :model-value="sitterStore.selectedSitter.rating || 5"
                color="amber"
                density="compact"
                readonly
                half-increments
              ></v-rating>
              <div class="text-h6 text-primary mt-2">
                {{ sitterStore.selectedSitter.priceHour}} $ / h
              </div>
            </div>
          </div>

          <v-divider class="my-8"></v-divider>

          <h3 class="text-h5 font-weight-bold mb-4">À propos</h3>
          <p class="text-body-1 text-grey-darken-2" style="white-space: pre-line;">
            {{ sitterStore.selectedSitter.description || "Ce gardien n'a pas encore rédigé de bio." }}
          </p>

          <v-btn
            block
            color="primary"
            size="x-large"
            class="rounded-xl mt-10"
            @click="isBookingOpen = true"
          >
            Réserver maintenant
          </v-btn>
        </v-card>
      </v-col>
    </v-row>

    <v-row v-else justify="center">
      <v-col cols="12" md="6">
        <v-alert type="error" variant="tonal" class="rounded-xl">
          Impossible de trouver les informations de ce gardien.
        </v-alert>
      </v-col>
    </v-row>

    <BookingModal
      v-model="isBookingOpen"
      :sitter="sitterStore.selectedSitter"
    />
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useSitterStore} from "@/stores/PetSitterStore.js";
import BookingModal from "@/frontend/components/BookingModal.vue"

const route = useRoute()
const sitterStore = useSitterStore()
const isBookingOpen = ref(false)

onMounted(async () => {
  const sitterId = route.params.id
  if (sitterId) {
    await sitterStore.fetchSitterById(sitterId)
  }
})
</script>
