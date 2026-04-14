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
              <v-avatar size="110" class="hero-avatar cursor-pointer" @click="triggerAvatarUpload">
                <v-img v-if="sitterStore.selectedSitter.photo" :src="sitterStore.selectedSitter.photo" cover></v-img>
                <v-icon v-else icon="mdi-account" size="64" color="white"></v-icon>
                <div class="avatar-overlay d-flex align-center justify-center">
                  <v-icon icon="mdi-camera" color="white" size="24"></v-icon>
                </div>
              </v-avatar>
              <input ref="avatarInput" type="file" accept="image/*" class="d-none" @change="handleAvatarUpload" />
              <div class="d-flex ga-2 mb-2">
                <v-chip v-if="sitterStore.selectedSitter.verifId" color="green" variant="tonal" size="small">
                  <v-icon icon="mdi-check-circle" start size="14"></v-icon>
                  Identité vérifiée
                </v-chip>
                <v-chip v-else color="red" variant="tonal" size="small">
                  <v-icon icon="mdi-close-circle" start size="14"></v-icon>
                  Identité non vérifiée
                </v-chip>
               <div class="d-flex ga-2 mb-2">
  <v-chip v-if="sitterStore.selectedSitter.verifId" color="green" variant="tonal" size="small">
    <v-icon icon="mdi-check-circle" start size="14"></v-icon>
    Identité vérifiée
  </v-chip>

  <v-btn
    :color="isEditMode ? 'orange' : 'amber'"
    variant="flat"
    size="small"
    class="rounded-pill"
    @click="toggleEditMode"
  >
    <v-icon :icon="isEditMode ? 'mdi-eye' : 'mdi-pencil'" start size="14"></v-icon>
    {{ isEditMode ? 'Voir Profil' : 'Modifier' }}
  </v-btn>
</div>
              </div>
            </div>

            <div class="mt-4">
              <h1 class="text-h4 font-weight-black">
                {{ userStore.user?.name }} {{ userStore.user?.lastName }}
              </h1>
              <p class="text-subtitle-1 text-grey-darken-1 mt-1">
                {{ userStore.user?.email }}
              </p>
            </div>
          </div>
        </v-card>

        <v-alert v-if="saveSuccess" type="success" variant="tonal" class="mb-6" closable>
          Profil mis à jour avec succès !
        </v-alert>
        <v-alert v-if="sitterStore.error" type="error" variant="tonal" class="mb-6">
          {{ sitterStore.error }}
        </v-alert>

        <v-row>
          <v-col cols="12" md="8">

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-4">
                <v-icon icon="mdi-account-outline" class="mr-2" color="white"></v-icon>
                À propos
              </h3>
              <v-textarea
                v-model="editForm.description"
                variant="outlined"
                :readonly="!isEditMode"
                placeholder="Décrivez votre expérience, vos compétences, votre approche..."
                auto-grow
                rows="4"
                density="comfortable"
              ></v-textarea>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-5">
                <v-icon icon="mdi-briefcase-outline" class="mr-2" color="white"></v-icon>
                Expérience & tarifs
              </h3>
              <v-row>
                <v-col cols="12" sm="4">
                  <div class="stat-box text-center pa-4 rounded-xl">
                    <v-icon icon="mdi-clock-outline" color="indigo" size="28" class="mb-2"></v-icon>
                    <v-text-field
                      v-model="editForm.experience"
                      type="number"
                      variant="underlined"
                      density="compact"
                      :readonly="!isEditMode"
                      suffix="ans"
                      hide-details
                      class="text-center input-black"
                    ></v-text-field>
                    <p class="text-caption text-grey mb-0 mt-1">d'expérience</p>
                  </div>
                </v-col>
                <v-col cols="12" sm="4">
                  <div class="stat-box text-center pa-4 rounded-xl">
                    <v-icon icon="mdi-currency-usd" color="green-darken-2" size="28" class="mb-2"></v-icon>
                    <v-text-field
                      v-model="editForm.tarifHoraire"
                      type="number"
                      variant="underlined"
                      :readonly="!isEditMode"
                      density="compact"
                      suffix="$/h"
                      hide-details
                      class="text-center input-black"
                    ></v-text-field>
                    <p class="text-caption text-grey mb-0 mt-1">tarif horaire</p>
                  </div>
                </v-col>
              </v-row>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-4">
                <v-icon icon="mdi-map-outline" class="mr-2" color="white"></v-icon>
                Zone de service
              </h3>
              <v-text-field
                v-model="editForm.zoneService"
                variant="outlined"
                density="comfortable"
                :readonly="!isEditMode"
                placeholder="Ex: Montréal, Laval..."
                prepend-inner-icon="mdi-map-marker"
              ></v-text-field>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <div class="d-flex align-center justify-space-between mb-5">
                <h3 class="section-title mb-0">
                  <v-icon icon="mdi-briefcase-check-outline" class="mr-2" color="white"></v-icon>
                  Mes services
                </h3>
                <v-btn color="indigo" variant="tonal" size="small" @click="addServiceDialog = true">
                  <v-icon icon="mdi-plus" start size="14"></v-icon>
                  Ajouter
                </v-btn>
              </div>

              <v-progress-linear v-if="serviceStore.loading" indeterminate color="indigo" class="mb-4"></v-progress-linear>

              <v-alert v-if="!serviceStore.loading && serviceStore.services.length === 0" type="info" variant="tonal">
                Aucun service ajouté pour le moment.
              </v-alert>

             <div v-for="service in serviceStore.services" :key="service.idService" class="service-item d-flex align-center justify-space-between mb-3">
  <div>
    <p class="font-weight-bold text-black mb-0">{{ service.typeService }}</p>
    <p class="text-caption text-grey mb-0">{{ service.description }} · {{ service.dureeEstimee }}h</p>
  </div>
  <div class="d-flex align-center ga-2">
    <v-btn icon size="x-small" variant="text" color="red" @click="handleRemoveService(service.idService)">
      <v-icon icon="mdi-delete-outline" size="18"></v-icon>
    </v-btn>
  </div>
</div>
            </v-card>

            <v-card flat border class="rounded-xl pa-6 mb-5">
              <h3 class="section-title mb-5">
                <v-icon icon="mdi-star-outline" class="mr-2" color="white"></v-icon>
                Avis reçus
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
                    <span class="text-body-2 font-weight-bold text-black">{{ avis.nomProprietaire }}</span>
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
                <span class="text-body-2 font-weight-bold text-black">Note moyenne</span>
                <v-chip color="amber-darken-2" variant="flat" size="large">
                  <v-icon icon="mdi-star" start size="16"></v-icon>
                  {{ avisStore.moyenne }} / 100
                </v-chip>
              </div>
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
                  <v-icon icon="mdi-email-outline" color="indigo" size="18"></v-icon>
                </v-avatar>
                <div>
                  <p class="text-caption text-grey mb-0">Email</p>
                  <p class="text-body-2 font-weight-bold mb-0">{{ userStore.user?.email }}</p>
                </div>
              </div>
              <div class="d-flex align-center" v-if="userStore.user?.adress">
                <v-avatar color="indigo-lighten-5" size="36" class="mr-3">
                  <v-icon icon="mdi-home-outline" color="indigo" size="18"></v-icon>
                </v-avatar>
                <div>
                  <p class="text-caption text-grey mb-0">Adresse</p>
                  <p class="text-body-2 font-weight-bold mb-0">{{ userStore.user?.adress }}</p>
                </div>
              </div>
            </v-card>

        <v-card flat border class="rounded-xl pa-6 mb-5">
  <h3 class="section-title mb-4">
    <v-icon icon="mdi-calendar-check" class="mr-2" color="white"></v-icon>
    Réservations
  </h3>

  <v-progress-linear v-if="reservationStore.loading" indeterminate color="indigo" class="mb-4"></v-progress-linear>

  <v-alert v-if="!reservationStore.loading && toutesLesReservations.length === 0" type="info" variant="tonal" density="compact">
    Aucune réservation pour le moment.
  </v-alert>

  <div v-for="r in toutesLesReservations" :key="r.idReservation" class="demande-item mb-3">
    <div class="d-flex align-center justify-space-between mb-1">
      <p class="text-body-2 font-weight-bold mb-0 text-black">
        Réservation #{{ r.idReservation }}
      </p>
      <v-chip :color="statutResColor(r.statut)" variant="tonal" size="x-small">
        {{ r.statut || 'CONFIRMÉE' }}
      </v-chip>
    </div>
    <p class="text-caption text-grey mb-1">
      {{ new Date(r.dateDebut).toLocaleDateString('fr-CA') }} – {{ new Date(r.dateFin).toLocaleDateString('fr-CA') }}
    </p>
    <v-chip color="green" variant="tonal" size="x-small" class="mb-2">{{ r.Totalprice }} $</v-chip>

    <div v-if="(r.statut || 'CONFIRMEE') === 'CONFIRMEE'" class="mt-2">
      <v-btn block color="orange" variant="tonal" size="x-small" @click="handleUpdateReservation(r.idReservation, 'EN_COURS')">
        <v-icon icon="mdi-play-circle" start size="14"></v-icon>
        Démarrer la garde
      </v-btn>
    </div>
    <div v-else-if="r.statut === 'EN_COURS'" class="mt-2">
      <v-btn block color="blue" variant="tonal" size="x-small" @click="handleUpdateReservation(r.idReservation, 'TERMINEE')">
        <v-icon icon="mdi-flag-checkered" start size="14"></v-icon>
        Terminer la garde
      </v-btn>
    </div>

    <v-divider class="mt-3" v-if="toutesLesReservations.indexOf(r) < toutesLesReservations.length - 1"></v-divider>
  </div>
</v-card>

            <v-card flat border class="rounded-xl pa-6 save-card">
              <v-btn
                block color="primary" size="x-large"
                class="rounded-xl font-weight-bold"
                :loading="sitterStore.loading"
                @click="handleSave"
              >
                <v-icon icon="mdi-content-save" start></v-icon>
                Enregistrer
              </v-btn>
            </v-card>

          </v-col>
        </v-row>

      </v-col>
    </v-row>

   <v-dialog v-model="addServiceDialog" max-width="480">
  <v-card class="pa-6 rounded-xl">
    <h3 class="text-h6 font-weight-black mb-4">Ajouter un service</h3>
    <v-text-field v-model="newService.typeService" label="Type de service" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
    <v-text-field v-model="newService.description" label="Description" variant="outlined" density="comfortable" class="mb-2"></v-text-field>
    <v-text-field v-model="newService.dureeEstimee" label="Durée estimée (h)" type="number" variant="outlined" density="comfortable" class="mb-4"></v-text-field>
    <div class="d-flex justify-end ga-2">
      <v-btn variant="text" @click="addServiceDialog = false">Annuler</v-btn>
      <v-btn color="primary" :loading="serviceStore.loading" @click="handleAddService">Ajouter</v-btn>
    </div>
  </v-card>
</v-dialog>
  </v-container>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useUserStore } from '@/stores/UserStore.js'
import { useSitterStore } from '@/stores/PetSitterStore.js'
import { useAvisStore } from '@/stores/avisStore.js'
import { useServiceStore } from '@/stores/ServiceStore.js'
import { useDemandeStore } from '@/stores/DemandeStore.js'
import { useReservationStore } from '@/stores/ReservationStore.js'




const userStore = useUserStore()
const sitterStore = useSitterStore()
const avisStore = useAvisStore()
const serviceStore = useServiceStore()
const demandeStore = useDemandeStore()
const reservationStore = useReservationStore()

const saveSuccess = ref(false)
const addServiceDialog = ref(false)
const avatarInput = ref(null)
const isEditMode = ref(false)

const editForm = reactive({
  description: '',
  experience: 0,
  tarifHoraire: 0,
  zoneService: '',
})

const newService = reactive({
  typeService: '',
  description: '',
  dureeEstimee: 0,
})

onMounted(async () => {
  const userId = userStore.userId
  if (userId) {
    await sitterStore.fetchSitterById(userId)
    await serviceStore.fetchServicesBySitter(userId)
    await avisStore.fetchAvisBySitter(userId)
    await avisStore.fetchMoyenneBySitter(userId)
    await demandeStore.fetchDemandesBySitter(userId)
    await reservationStore.fetchConfirmedReservationsByUser(userId)
    await reservationStore.fetchPastReservationsByUser(userId)

    if (sitterStore.selectedSitter) {
      editForm.description = sitterStore.selectedSitter.description || ''
      editForm.experience = sitterStore.selectedSitter.experience || 0
      editForm.tarifHoraire = sitterStore.selectedSitter.priceHour || 0
      editForm.zoneService = sitterStore.selectedSitter.zoneService || ''
    }
  }
})

const handleSave = async () => {
  saveSuccess.value = false
  try {
    await sitterStore.updateSitterProfile(userStore.userId, editForm)
  } catch (e) {
    console.error(e)
  }
}
const toutesLesReservations = computed(() => [
  ...reservationStore.confirmedReservation,
  ...reservationStore.pastReservations,
])

const statutResColor = (statut) => {
  switch (statut) {
    case 'CONFIRMEE':  return 'green'
    case 'EN_COURS': return 'orange'
    case 'TERMINEE':   return 'blue'
    default:           return 'green'
  }
}
const handleAddService = async () => {
  try {
    await serviceStore.createService(
      userStore.userId,
      newService.typeService,
      newService.description,
      newService.dureeEstimee
    )
    addServiceDialog.value = false
    Object.assign(newService, { typeService: '', description: '', dureeEstimee: 0 })
  } catch (e) {
    console.error(e)
  }
}

const handleRemoveService = async (serviceId) => {
  await serviceStore.removeService(serviceId, userStore.userId)
}

const handleUpdateDemande = async (demandeId, statut) => {
  await demandeStore.updateStatut(demandeId, statut)
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
    await sitterStore.fetchSitterById(userStore.userId)
  }
  reader.readAsDataURL(file)
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
const toggleEditMode = () => {
  if (isEditMode.value) {
    resetForm()
  }
  isEditMode.value = !isEditMode.value
}

const resetForm = () => {
  if (sitterStore.selectedSitter) {
    editForm.description = sitterStore.selectedSitter.description || ''
    editForm.experience = sitterStore.selectedSitter.experience || 0
    editForm.tarifHoraire = sitterStore.selectedSitter.priceHour || 0
    editForm.tariffJournalier = sitterStore.selectedSitter.tariffJournalier || 0
    editForm.zoneService = sitterStore.selectedSitter.zoneService || ''
  }
}

const handleUpdateReservation = async (reservationId, statut) => {
  try {
    await reservationStore.updateReservationStatus(reservationId, statut)
    await reservationStore.fetchConfirmedReservationsByUser(userStore.userId)
    await reservationStore.fetchPastReservationsByUser(userStore.userId)
  } catch (e) {
    console.error(e)
  }
}

</script>

<style scoped>
.hero-banner { height: 160px; background: linear-gradient(135deg, #3949AB, #18b4d1); }
.hero-avatar { margin-top: -55px; border: 4px solid white !important; position: relative; }
.hero-avatar-row { margin-top: -10px; }
.avatar-overlay {
  position: absolute; inset: 0;
  background: rgba(0,0,0,0.4);
  border-radius: 50%;
  opacity: 0;
  transition: opacity 0.2s;
}
.hero-avatar:hover .avatar-overlay { opacity: 1; }
.stat-box { background: #F8F9FF; border: 1px solid #E8EAFF; }
.section-title { font-size: 1rem; font-weight: 800; color: #ffffff; }
.save-card { background: #F8F9FF !important; border-color: #E8EAFF !important; }
.avis-item { background: #F8F9FF; border-radius: 10px; padding: 14px 16px; }
.moyenne-box { background: #FFFBF0; border: 1px solid #FFE082; }
.service-item { background: #F8F9FF; border-radius: 10px; padding: 12px 16px; }
.demande-item { background: #F8F9FF; border-radius: 10px; padding: 12px 16px; }
.input-black :deep(input) { color: #1a1a1a !important; }
.input-black :deep(.v-field__suffix) { color: #1a1a1a !important; }
</style>
