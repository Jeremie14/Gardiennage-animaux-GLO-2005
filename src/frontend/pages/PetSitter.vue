<template>
  <v-container class="py-10">
    <v-row v-if="sitterStore.loading" justify="center" class="py-10">
      <v-progress-circular indeterminate color="primary" size="64"></v-progress-circular>
    </v-row>

    <v-row v-else-if="sitterStore.selectedSitter" justify="center">
      <v-col cols="12" md="9">

        <v-card flat border class="rounded-xl overflow-hidden mb-6">
          <div class="hero-banner"></div>
          <div class="px-8 pb-8">
            <div class="d-flex align-end justify-space-between hero-avatar-row">
              <v-avatar size="110" class="hero-avatar border-white">
               <v-img
                v-if="sitterStore.selectedSitter.photo"
                :src="sitterStore.selectedSitter.photo"
                cover
              ></v-img>
              <v-icon v-else icon="mdi-account" size="64" color="white"></v-icon>
              </v-avatar>
              <div class="d-flex ga-2 mb-2">
                <v-chip v-if="sitterStore.selectedSitter.verifId" color="green" variant="tonal" size="small">
                  <v-icon icon="mdi-check-circle" start size="14"></v-icon>
                  Identité vérifiée
                </v-chip>
                <v-chip v-if="!sitterStore.selectedSitter.verifId" color="red" variant="tonal" size="small">
                  <v-icon icon="mdi-close-circle" start size="14"></v-icon>
                  Identité non vérifiée
                </v-chip>
                <v-chip color="indigo" variant="tonal" size="small">
                  Gardien professionnel
                </v-chip>
              </div>
            </div>

            <div class="mt-4 d-flex align-start justify-space-between flex-wrap ga-4">
              <div>
                <h1 class="text-h4 font-weight-black">
                  {{ sitterStore.selectedSitter.name }} {{ sitterStore.selectedSitter.lastName }}
                </h1>
              </div>
            </div>
          </div>
        </v-card>
        <v-row>
          <v-col cols="12" md="8">

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-4">
                <v-icon icon="mdi-account-outline" class="mr-2" color="white"></v-icon>
                À propos
              </h3>
              <p class="text-body-1 text-grey-lighten-2" style="white-space: pre-line; line-height: 1.8">
                {{ sitterStore.selectedSitter.description || "Ce gardien n'a pas encore rédigé de bio." }}
              </p>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-5">
                <v-icon icon="mdi-briefcase-outline" class="mr-2" color="white"></v-icon>
                Expérience & tarifs
              </h3>
              <v-row>
                <v-col cols="6" sm="4">
                  <div class="stat-box text-center pa-4 rounded-xl">
                    <v-icon icon="mdi-clock-outline" color="indigo" size="28" class="mb-2"></v-icon>
                    <p class="text-h5 font-weight-black text-indigo-darken-1 mb-0">
                      {{ sitterStore.selectedSitter.experience }}
                    </p>
                    <p class="text-caption text-grey mb-0">ans d'expérience</p>
                  </div>
                </v-col>
                <v-col cols="6" sm="4">
                  <div class="stat-box text-center pa-4 rounded-xl">
                    <v-icon icon="mdi-currency-usd" color="green-darken-2" size="28" class="mb-2"></v-icon>
                    <p class="text-h5 font-weight-black text-green-darken-2 mb-0">
                      {{ sitterStore.selectedSitter.priceHour }} $
                    </p>
                    <p class="text-caption text-grey mb-0">/ heure</p>
                  </div>
                </v-col>

              </v-row>
            </v-card>
 <v-card flat border class="rounded-xl pa-6 mb-5">
  <h3 class="section-title mb-5">
    <v-icon icon="mdi-star-outline" class="mr-2" color="white"></v-icon>
    Avis
  </h3>

  <v-progress-linear v-if="avisStore.loading" indeterminate color="amber" class="mb-4"></v-progress-linear>

  <v-alert v-if="!avisStore.loading && avisStore.avis.length === 0" type="info" variant="tonal">
    Aucun avis pour le moment.
  </v-alert>

  <div v-for="avis in avisStore.avis" :key="avis.idAvis" class="avis-item mb-4">
    <div class="d-flex align-center justify-space-between mb-1">
      <div class="d-flex align-center ga-2">
       <v-avatar color="indigo-lighten-5" size="32">
  <v-img v-if="avis.photoProprietaire" :src="avis.photoProprietaire" cover></v-img>
  <v-icon v-else icon="mdi-account" color="indigo" size="18"></v-icon>
</v-avatar>
<span class="text-body-2 font-weight-bold">{{ avis.nomProprietaire }}</span>

      </div>
      <div class="d-flex align-center ga-2">
        <v-chip color="amber-darken-2" variant="tonal" size="small">
          <v-icon icon="mdi-star" start size="12"></v-icon>
          {{ avis.note }} / 100
        </v-chip>
        <span class="text-caption text-grey">{{ new Date(avis.dateAvis).toLocaleDateString('fr-CA') }}</span>
      </div>
    </div>
    <p class="text-body-2 text-grey-darken-1 ml-10 mb-0">{{ avis.commentaire }}</p>
    <v-divider class="mt-4" v-if="avisStore.avis.indexOf(avis) < avisStore.avis.length - 1"></v-divider>
  </div>

  <div v-if="avisStore.moyenne !== null" class="moyenne-box d-flex align-center justify-space-between pa-4 rounded-xl mt-4">
    <span class="text-body-2 font-weight-bold">Note moyenne</span>
    <v-chip color="amber-darken-2" variant="flat" size="large">
      <v-icon icon="mdi-star" start size="16"></v-icon>
      {{ avisStore.moyenne }} / 100
    </v-chip>
  </div>
</v-card>
            <v-card flat border class="rounded-xl pa-6 mb-5" v-if="sitterStore.selectedSitter.zoneService">
              <h3 class="section-title mb-4">
                <v-icon icon="mdi-map-outline" class="mr-2" color="white"></v-icon>
                Zone de service
              </h3>
              <v-chip color="indigo" variant="tonal" size="large">
                <v-icon icon="mdi-map-marker" start></v-icon>
                {{ sitterStore.selectedSitter.zoneService }}
              </v-chip>
            </v-card>

          </v-col>

          <v-col cols="12" md="4">

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-4">
                <v-icon icon="mdi-card-account-details-outline" class="mr-2" color="white"></v-icon>
                Contact
              </h3>
              <div class="d-flex align-center mb-3">
                <v-avatar color="indigo-lighten-5" size="36" class="mr-3">
                  <v-icon icon="mdi-email-outline" color="white" size="18"></v-icon>
                </v-avatar>
                <div>
                  <p class="text-caption text-grey mb-0">Email</p>
                  <p class="text-body-2 font-weight-bold text-grey mb-0">{{ sitterStore.selectedSitter.email }}</p>
                </div>
              </div>
              <div class="d-flex align-center" v-if="sitterStore.selectedSitter.adress">
                <v-avatar color="indigo-lighten-5" size="36" class="mr-3">
                  <v-icon icon="mdi-home-outline" color="white" size="18"></v-icon>
                </v-avatar>
                <div>
                  <p class="text-caption text-grey mb-0">Adresse</p>
                  <p class="text-body-2 font-weight-bold mb-0">{{ sitterStore.selectedSitter.adress }}</p>
                </div>
              </div>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 cta-card">
              <p class="text-body-2 text-grey-darken-1 mb-4 text-center">
                Disponible pour garder vos animaux
              </p>
              <v-btn
                block color="primary" size="x-large"
                class="rounded-xl font-weight-bold mb-3"
                @click="isBookingOpen = true"
              >
                <v-icon icon="mdi-calendar-plus" start></v-icon>
                Réserver maintenant
              </v-btn>
            </v-card>

          </v-col>
        </v-row>

      </v-col>
    </v-row>

    <v-row v-else justify="center">
      <v-col cols="12" md="6">
        <v-alert type="error" variant="tonal" class="rounded-xl">
          Impossible de trouver les informations de ce gardien.
        </v-alert>
      </v-col>
    </v-row>

    <BookingModal v-model="isBookingOpen" :sitter="sitterStore.selectedSitter" />
  </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useSitterStore } from '@/stores/PetSitterStore.js'
import { useAvisStore } from '@/stores/avisStore.js'
import BookingModal from '@/frontend/components/BookingModal.vue'

const route = useRoute()
const sitterStore = useSitterStore()
const avisStore = useAvisStore()
const isBookingOpen = ref(false)

onMounted(async () => {
  const sitterId = route.params.id
  if (sitterId) {
    await sitterStore.fetchSitterById(sitterId)
    await avisStore.fetchAvisBySitter(sitterId)
    await avisStore.fetchMoyenneBySitter(sitterId)
  }
})
</script>

<style scoped>
.hero-banner {
  height: 160px;
  background: linear-gradient(135deg, #3949AB, #18b4d1);
}
.hero-avatar {
  margin-top: -55px;
  border: 4px solid white !important;
}
.hero-avatar-row {
  margin-top: -10px;
}

.stat-box {
  background: #F8F9FF;
  border: 1px solid #E8EAFF;
}
.section-title {
  font-size: 1rem;
  font-weight: 800;
  color: #ffffff;
}
.cta-card {
  background: #F8F9FF;
  border-color: #E8EAFF;
}
</style>
