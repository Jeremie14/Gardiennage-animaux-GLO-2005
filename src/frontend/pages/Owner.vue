<template>
  <v-main class="bg-grey-lighten-4 min-vh-100">
    <v-container class="py-10">

      <header class="d-flex align-center justify-space-between mb-10">
        <div class="d-flex align-center">
          <v-avatar color="primary" size="64" class="mr-4 text-h5 font-weight-bold cursor-pointer" @click="triggerAvatarUpload">
            <v-img v-if="userStore.user.picture" :src="userStore.user.picture" cover></v-img>
            <span v-else>{{ userInitials }}</span>
          </v-avatar>
          <input ref="avatarInput" type="file" accept="image/*" class="d-none" @change="handleAvatarUpload" />
          <div>
            <h1 class="text-h4 font-weight-black text-grey-darken-4">Bonjour, {{ userStore.user?.lastName }}</h1>
            <p class="text-subtitle-1 text-grey-darken-1">
              {{ new Date().toLocaleDateString('fr-CA', { weekday: 'long', month: 'long', day: 'numeric' }) }}
            </p>
          </div>
        </div>
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
        <v-alert v-if="animalStore.error" type="error" variant="tonal" class="mb-4">{{ animalStore.error }}</v-alert>
        <v-row>
          <v-col v-for="pet in animalStore.animals" :key="pet.idAnimal" cols="12" sm="6" md="4">
            <AnimalCard :animal="pet" @delete="handleDeleteAnimal(pet.idAnimal)" />
          </v-col>
          <v-col cols="12" sm="6" md="4">
            <v-card flat border
              class="add-pet-card rounded-xl d-flex flex-column align-center justify-center cursor-pointer bg-white"
              @click="openAddDialog">
              <v-icon icon="mdi-plus" size="32" color="indigo-lighten-2"></v-icon>
              <span class="text-indigo-lighten-1 font-weight-bold mt-2">Ajouter un animal</span>
            </v-card>
          </v-col>
        </v-row>
      </section>
      <section class="mt-12">
  <div class="d-flex align-center mb-6">
    <h2 class="section-title mb-0">Mes demandes</h2>
    <v-divider class="ml-4"></v-divider>
  </div>

  <v-progress-linear v-if="demandeStore.loading" indeterminate color="primary" class="mb-4"></v-progress-linear>
  <v-alert v-if="demandeStore.error" type="error" variant="tonal" class="mb-4">{{ demandeStore.error }}</v-alert>
  <v-alert v-if="!demandeStore.loading && demandeStore.demandes.length === 0" type="info" variant="tonal">
    Aucune demande pour le moment.
  </v-alert>

  <v-card
    v-for="demande in demandeStore.demandes"
    :key="demande.idDemande"
    border flat class="rounded-xl pa-6 bg-white mb-4"
  >
    <div class="d-flex align-center flex-wrap ga-3">
      <v-avatar :color="demandeStatutColor(demande.statutDemande) + '-lighten-5'" size="50" class="mr-2">
        <v-icon :icon="demandeStatutIcon(demande.statutDemande)" :color="demandeStatutColor(demande.statutDemande)"></v-icon>
      </v-avatar>
      <div>
        <p class="font-weight-bold mb-0">Demande #{{ demande.idDemande }}</p>
        <p class="text-caption text-grey mb-0">
          {{ new Date(demande.dateDebut).toLocaleDateString('fr-CA') }}
          –
          {{ new Date(demande.dateFin).toLocaleDateString('fr-CA') }}
        </p>
        <p class="text-caption text-grey mb-0" v-if="demande.message">
          "{{ demande.message }}"
        </p>
      </div>
      <v-spacer></v-spacer>
      <v-chip :color="demandeStatutColor(demande.statutDemande)" variant="tonal" size="small">
        <v-icon :icon="demandeStatutIcon(demande.statutDemande)" start size="14"></v-icon>
        {{ demande.statutDemande }}
      </v-chip>
      <p class="text-caption text-grey mb-0">Créée le {{ new Date(demande.dateCreation).toLocaleDateString('fr-CA') }}</p>
    </div>
  </v-card>
</section>
      <section class="mb-12">
        <div class="d-flex align-center mb-6">
          <h2 class="section-title mb-0">Réservations à venir</h2>
          <v-divider class="ml-4"></v-divider>
        </div>
        <v-progress-linear v-if="reservationStore.loading" indeterminate color="primary" class="mb-4"></v-progress-linear>
        <v-alert v-if="reservationStore.error" type="error" variant="tonal" class="mb-4">{{ reservationStore.error }}</v-alert>
        <v-alert v-if="!reservationStore.loading && reservationStore.confirmedReservation.length === 0" type="info" variant="tonal">
          Aucune réservation confirmée pour le moment.
        </v-alert>

        <v-card
          v-for="reservation in reservationStore.confirmedReservation"
          :key="reservation.idReservation"
          border flat class="rounded-xl pa-6 bg-white mb-4"
        >
          <div class="d-flex align-center flex-wrap ga-3">
            <v-avatar color="indigo-lighten-5" size="50" class="mr-2">
              <v-icon icon="mdi-calendar-check" color="primary"></v-icon>
            </v-avatar>
            <div>
              <p class="font-weight-bold mb-0">Réservation #{{ reservation.idReservation }}</p>
              <p class="text-caption text-grey mb-0">
                {{ new Date(reservation.dateDebut).toLocaleDateString('fr-CA') }}
                –
                {{ new Date(reservation.dateFin).toLocaleDateString('fr-CA') }}
              </p>
            </div>
            <v-spacer></v-spacer>
            <v-chip color="green" variant="tonal" size="small">
              <v-icon icon="mdi-check-circle" start size="14"></v-icon>
              CONFIRMÉE
            </v-chip>
            <v-chip color="green" variant="tonal" size="small">{{ reservation.Totalprice }} $</v-chip>
            <v-btn variant="tonal" color="primary" size="small" class="rounded-lg" @click="openDetailDialog(reservation)">
              Voir les détails
            </v-btn>
          </div>
        </v-card>
      </section>

      <section>
        <div class="d-flex align-center mb-6">
          <h2 class="section-title mb-0">Réservations passées</h2>
          <v-divider class="ml-4"></v-divider>
        </div>
        <v-alert v-if="!reservationStore.loading && reservationStore.pastReservations.length === 0" type="info" variant="tonal">
          Aucune réservation passée pour le moment.
        </v-alert>

        <v-card
          v-for="reservation in reservationStore.pastReservations"
          :key="reservation.idReservation"
          border flat class="rounded-xl pa-6 bg-white mb-4"
          style="opacity: 0.8"
        >
          <div class="d-flex align-center flex-wrap ga-3">
            <v-avatar color="grey-lighten-3" size="50" class="mr-2">
              <v-icon icon="mdi-calendar-clock" color="grey-darken-1"></v-icon>
            </v-avatar>
            <div>
              <p class="font-weight-bold mb-0">Réservation #{{ reservation.idReservation }}</p>
              <p class="text-caption text-grey mb-0">
                {{ new Date(reservation.dateDebut).toLocaleDateString('fr-CA') }}
                –
                {{ new Date(reservation.dateFin).toLocaleDateString('fr-CA') }}
              </p>
            </div>
            <v-spacer></v-spacer>
            <v-chip :color="statutColor(reservation.statut)" variant="tonal" size="small">
              <v-icon :icon="statutIcon(reservation.statut)" start size="14"></v-icon>
              {{ reservation.statut || 'PASSÉE' }}
            </v-chip>
            <v-chip color="grey" variant="tonal" size="small">{{ reservation.Totalprice }} $</v-chip>
            <v-btn variant="tonal" color="grey-darken-1" size="small" class="rounded-lg" @click="openDetailDialog(reservation)">
              Voir les détails
            </v-btn>
            <v-btn
              v-if="reservation.statut === 'TERMINEE'"
              variant="tonal"
              color="amber-darken-2"
              size="small"
              class="rounded-lg"
              @click="openAvisDialog(reservation)"
            >
              <v-icon icon="mdi-star-outline" start size="14"></v-icon>
              Donner votre avis
            </v-btn>
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
<v-text-field v-model="newAnimal.specialNeeds" label="Besoins spéciaux" variant="outlined" density="comfortable" class="mb-4"></v-text-field>        <div class="d-flex justify-end ga-2">
          <v-btn variant="text" @click="addDialog = false">Annuler</v-btn>
          <v-btn color="primary" :loading="animalStore.loading" @click="handleAddAnimal">Ajouter</v-btn>
        </div>
      </v-card>
    </v-dialog>

    <v-dialog v-model="detailDialog" max-width="620" scrollable>
      <v-card class="rounded-xl overflow-hidden" v-if="selectedReservation">

        <div class="detail-header pa-6 d-flex align-center justify-space-between">
          <div>
            <v-chip
              :color="statutColor(selectedReservation.statut)"
              variant="tonal"
              size="small"
              class="mb-2"
            >
              <v-icon :icon="statutIcon(selectedReservation.statut)" start size="14"></v-icon>
              {{ selectedReservation.statut || 'CONFIRMÉE' }}
            </v-chip>
            <h3 class="text-h5 font-weight-black text-white">#{{ selectedReservation.idReservation }}</h3>
          </div>
          <v-chip color="white" variant="tonal" size="large" class="font-weight-bold text-indigo-darken-2">
            {{ selectedReservation.Totalprice }} $
          </v-chip>
        </div>

        <v-card-text class="pa-6" style="max-height: 70vh; overflow-y: auto;">

          <div class="detail-section mb-5">
            <p class="detail-section-title">
              <v-icon icon="mdi-calendar-range" size="16" class="mr-1"></v-icon>
              Période de garde
            </p>
            <v-row>
              <v-col cols="6">
                <div class="detail-box">
                  <p class="detail-box-label">Début</p>
                  <p class="detail-box-value">{{ new Date(selectedReservation.dateDebut).toLocaleDateString('fr-CA', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) }}</p>
                </div>
              </v-col>
              <v-col cols="6">
                <div class="detail-box">
                  <p class="detail-box-label">Fin</p>
                  <p class="detail-box-value">{{ new Date(selectedReservation.dateFin).toLocaleDateString('fr-CA', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }) }}</p>
                </div>
              </v-col>
            </v-row>
          </div>

          <v-divider class="mb-5"></v-divider>

          <div class="detail-section mb-5">
            <p class="detail-section-title">
              <v-icon icon="mdi-paw" size="16" class="mr-1"></v-icon>
              Animal
            </p>
            <div v-if="detailAnimal" class="detail-box d-flex align-center">
              <v-avatar color="indigo-lighten-5" size="48" class="mr-4">
                <v-icon icon="mdi-dog" color="primary"></v-icon>
              </v-avatar>
              <div>
                <p class="detail-box-value mb-0">{{ detailAnimal.name }}</p>
                <p class="detail-box-label mb-0">{{ detailAnimal.species }} · {{ detailAnimal.race }} · {{ detailAnimal.age }} ans · {{ detailAnimal.sexe }}</p>
                <p class="detail-box-label mb-0" v-if="detailAnimal.temper">Tempérament : {{ detailAnimal.temper }}</p>
                <p class="detail-box-label mb-0" v-if="detailAnimal.specialNeeds">Besoins spéciaux : {{ detailAnimal.specialNeeds }}</p>
              </div>
            </div>
            <v-skeleton-loader v-else type="list-item-avatar"></v-skeleton-loader>
          </div>

          <v-divider class="mb-5"></v-divider>

          <div class="detail-section mb-5">
            <p class="detail-section-title">
              <v-icon icon="mdi-account-heart" size="16" class="mr-1"></v-icon>
              Gardien
            </p>
            <div v-if="detailSitter" class="detail-box d-flex align-center">
              <v-avatar color="green-lighten-5" size="48" class="mr-4">
                <v-icon icon="mdi-account" color="green-darken-2"></v-icon>
              </v-avatar>
              <div>
                <p class="detail-box-value mb-0">{{ detailSitter.name }} {{ detailSitter.latName }}</p>
                <p class="detail-box-label mb-0">{{ detailSitter.email }}</p>
                <p class="detail-box-label mb-0" v-if="detailSitter.adress">{{ detailSitter.adress }}</p>
                <p class="detail-box-label mb-0" v-if="detailSitter.experience">{{ detailSitter.experience }} ans d'expérience</p>
              </div>
            </div>
            <v-skeleton-loader v-else type="list-item-avatar"></v-skeleton-loader>
          </div>

          <v-divider class="mb-5"></v-divider>

          <div class="detail-section mb-2" v-if="selectedReservation.message">
            <p class="detail-section-title">
              <v-icon icon="mdi-message-text" size="16" class="mr-1"></v-icon>
              Message
            </p>
            <div class="detail-box">
              <p class="detail-box-value mb-0">{{ selectedReservation.message }}</p>
            </div>
          </div>

          <p class="text-caption text-grey mt-4">
            Confirmée le {{ new Date(selectedReservation.dateConfirmation).toLocaleDateString('fr-CA') }}
            · Créée le {{ new Date(selectedReservation.dateCreation).toLocaleDateString('fr-CA') }}
          </p>

        </v-card-text>

        <v-card-actions class="pa-6 pt-0 d-flex justify-end">
          <v-btn variant="text" @click="detailDialog = false">Fermer</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  <v-dialog v-model="avisDialog" max-width="480">
  <v-card class="pa-6 rounded-xl" v-if="selectedReservationAvis">
    <h3 class="text-h6 font-weight-black mb-1">Donner votre avis</h3>
    <p class="text-caption text-grey mb-4">Réservation #{{ selectedReservationAvis.idReservation }}</p>

    <p class="detail-section-title mb-2">Note</p>

<div class="d-flex align-center ga-4 mb-4">
  <v-slider
    v-model="newAvis.note"
    :min="0"
    :max="100"
    :step="1"
    color="amber-darken-2"
    track-color="grey-lighten-2"
    thumb-label
    hide-details
  ></v-slider>
  <span class="text-h6 font-weight-black text-amber-darken-2" style="min-width: 60px;">
    {{ newAvis.note }} / 100
  </span>
</div>

    <v-textarea
      v-model="newAvis.commentaire"
      label="Commentaire"
      variant="outlined"
      density="comfortable"
      rows="3"
      class="mb-4"
    ></v-textarea>

    <div class="d-flex justify-end ga-2">
      <v-btn variant="text" @click="avisDialog = false">Annuler</v-btn>
      <v-btn color="amber-darken-2" :loading="avisLoading" @click="handleSubmitAvis">Envoyer</v-btn>
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
import { useReservationStore } from '@/stores/ReservationStore.js'
import animalService from '@/service/animalService'
import sitterService from '@/service/sitterService'
import { useAvisStore } from '@/stores/avisStore.js'
import { useDemandeStore } from '@/stores/DemandeStore.js'

const userStore = useUserStore()
const animalStore = useAnimalStore()
const reservationStore = useReservationStore()
const avisStore = useAvisStore()
const demandeStore = useDemandeStore()

const addDialog = ref(false)
const detailDialog = ref(false)
const selectedReservation = ref(null)
const detailAnimal = ref(null)
const detailSitter = ref(null)
const avatarInput = ref(null)
const avisDialog = ref(false)
const avisLoading = ref(false)
const selectedReservationAvis = ref(null)
const newAvis = ref({ note: 0, commentaire: '' })

const newAnimal = ref({
  name: '', species: '', race: '', age: null, weight: null,
  sexe: null, temper: '', specialNeeds: ''
})

const userInitials = computed(() => {
  const p = userStore.user?.name?.[0] ?? ''
  const n = userStore.user?.lastName?.[0] ?? ''
  return (p + n).toUpperCase()
})

const stats = computed(() => [
  { label: 'Mes animaux', value: animalStore.animalCount },
  { label: 'Gardes à venir', value: reservationStore.confirmedReservation.length },
  { label: 'Réservations passées', value: reservationStore.pastReservations.length },
])

const statutColor = (statut) => {
  switch (statut) {
    case 'CONFIRMEE':  return 'green'
    case 'ANNULEE':    return 'red'
    case 'EN_ATTENTE': return 'orange'
    case 'TERMINEE':   return 'blue'
    default:           return 'grey'
  }
}
const demandeStatutColor = (statut) => {
  switch (statut) {
    case 'ACCEPTEE':   return 'green'
    case 'REFUSEE':    return 'red'
    case 'EN_ATTENTE': return 'orange'
    case 'ANNULEE':    return 'grey'
    default:           return 'grey'
  }
}

const statutIcon = (statut) => {
  switch (statut) {
    case 'CONFIRMEE':  return 'mdi-check-circle'
    case 'ANNULEE':    return 'mdi-close-circle'
    case 'EN_ATTENTE': return 'mdi-clock-outline'
    case 'TERMINEE':   return 'mdi-flag-checkered'
    default:           return 'mdi-calendar-clock'
  }
}

const demandeStatutIcon = (statut) => {
  switch (statut) {
    case 'ACCEPTEE':   return 'mdi-check-circle'
    case 'REFUSEE':    return 'mdi-close-circle'
    case 'EN_ATTENTE': return 'mdi-clock-outline'
    case 'ANNULEE':    return 'mdi-cancel'
    default:           return 'mdi-help-circle'
  }
}

onMounted(() => {
  if (userStore.userId) {
    userStore.getUser(userStore.userId)
    animalStore.fetchAnimals(userStore.userId)
    reservationStore.fetchConfirmedReservationsByUser(userStore.userId)
    reservationStore.fetchPastReservationsByUser(userStore.userId)
    demandeStore.fetchDemandesByOwner(userStore.userId)
  }
})

const openDetailDialog = async (reservation) => {
  selectedReservation.value = reservation
  detailAnimal.value = null
  detailSitter.value = null
  detailDialog.value = true

  const [animal, sitter] = await Promise.all([
    animalService.getAnimalById(reservation.idAnimal),
    sitterService.getSitterById(reservation.idGardien),
  ])

  detailAnimal.value = animal
  detailSitter.value = sitter
}

const openAddDialog = () => {
  newAnimal.value = { name: '', species: '', race: '', age: null, weight: null, sexe: null, temper: '', specialNeeds: '' }
  addDialog.value = true
}

const handleAddAnimal = async () => {
  await animalStore.addAnimal({ ...newAnimal.value, idProprietaire: userStore.userId })
  addDialog.value = false
}

const handleDeleteAnimal = async (animalId) => {
  await animalStore.removeAnimal(animalId, userStore.userId)
}

const triggerAvatarUpload = () => {
  avatarInput.value.click()
}

const handleAvatarUpload = (event) => {
  const file = event.target.files[0]
  if (!file) return

  const reader = new FileReader()
  reader.onload = async (e) => {
    await userStore.updateUserPic(userStore.user.id, e.target.result)
    localStorage.setItem('picture', e.target.result)
  }
  reader.readAsDataURL(file)
}

const openAvisDialog = (reservation) => {
  selectedReservationAvis.value = reservation
  newAvis.value = { note: 0, commentaire: '' }
  avisDialog.value = true
}

const handleSubmitAvis = async () => {
  try {
    await avisStore.createAvis(
      newAvis.value.note,
      newAvis.value.commentaire,
      new Date().toISOString().split('T')[0],
      userStore.userId,
      selectedReservationAvis.value.idGardien,
      selectedReservationAvis.value.idReservation,
    )
    avisDialog.value = false
  } catch (e) {
    console.error(e)
  }
}
</script>

<style scoped>
.min-vh-100 { min-height: 100vh; }
.section-title { color: #1a1a1a; font-size: 1.25rem; font-weight: 800; margin-bottom: 24px; }
.stat-label { color: #757575; font-weight: 600; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }
.stat-value { font-size: 2.5rem; font-weight: 900; line-height: 1.2; }
.add-pet-card { border: 2px dashed #E0E0E0 !important; height: 100%; min-height: 160px; transition: all 0.3s ease; }
.add-pet-card:hover { border-color: #5C6BC0 !important; background-color: #F5F7FF !important; }
.detail-header { background: linear-gradient(135deg, #3949AB, #5C6BC0); }
.detail-section-title { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: #9E9E9E; margin-bottom: 10px; }
.detail-box { background: #F8F9FF; border-radius: 10px; padding: 14px 16px; }
.detail-box-label { font-size: 0.78rem; color: #9E9E9E; margin-bottom: 2px; }
.detail-box-value { font-size: 0.95rem; font-weight: 700; color: #1a1a1a; }
</style>
