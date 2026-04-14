<template>

  <v-container class="py-10">
    <div class="d-flex align-center justify-space-between mb-8">
      <div>
        <h1 class="text-h4 font-weight-black text-black">Mes Demandes de Réservations</h1>
        <p class="text-subtitle-1 text-grey-darken-1">Gérez vos demandes de garde et votre emploi du temps</p>
      </div>
      <v-chip color="indigo" variant="tonal" class="font-weight-bold">
        {{ bookings.length }} demande(s) au total
      </v-chip>
    </div>

    <v-row v-if="demandeStore.loading" justify="center" class="py-10">
      <v-progress-circular indeterminate color="primary" size="64"></v-progress-circular>
    </v-row>

    <v-row v-else-if="bookings.length === 0" justify="center" class="py-10">
      <v-col cols="12" md="6" class="text-center">
        <v-icon icon="mdi-calendar-blank" size="100" color="grey-lighten-2" class="mb-4"></v-icon>
        <h3 class="text-h5 text-grey-darken-1">Aucune réservation trouvée</h3>
        <p class="text-grey">Les nouvelles demandes apparaîtront ici dès qu'un propriétaire vous contactera.</p>
      </v-col>
    </v-row>

    <v-row v-else>
      <v-col v-for="booking in bookings" :key="booking.idDemande" cols="12" md="6" lg="4">
        <v-card border flat class="rounded-xl hover-card">
          <v-card-text class="pa-6">
            <div class="d-flex justify-space-between align-start mb-4">
              <div class="d-flex align-center ga-3">
                <v-avatar color="indigo-lighten-5" size="48">
                  <v-img v-if="booking.photoProprietaire" :src="booking.photoProprietaire" cover></v-img>
                  <v-icon v-else icon="mdi-account" color="indigo"></v-icon>
                </v-avatar>
                <div>
                  <p class="text-body-2 font-weight-bold mb-0 text-black">Demande #{{ booking.idDemande }}</p>
                  <h3 class="text-subtitle-1 font-weight-black">{{ booking.nomProprietaire || 'Client' }}</h3>
                </div>
              </div>
              <v-chip :color="getStatusColor(booking.statutDemande)" variant="flat" size="small" class="font-weight-bold">
                {{ booking.statutDemande }}
              </v-chip>
            </div>

            <v-divider class="mb-4"></v-divider>

            <div class="d-flex flex-column ga-2 mb-6">
              <div class="d-flex align-center text-body-2">
                <v-icon icon="mdi-calendar-range" start color="grey" size="18"></v-icon>
                <span>Du <strong>{{ formatDate(booking.dateDebut) }}</strong></span>
              </div>
              <div class="d-flex align-center text-body-2">
                <v-icon icon="mdi-calendar-check" start color="grey" size="18"></v-icon>
                <span>Au <strong>{{ formatDate(booking.dateFin) }}</strong></span>
              </div>
              <div v-if="booking.nomAnimal" class="d-flex align-center text-body-2">
                <v-icon icon="mdi-paw" start color="grey" size="18"></v-icon>
                <span>Animal : {{ booking.nomAnimal }} </span>
              </div>
            </div>

            <div v-if="booking.statutDemande === 'EN_ATTENTE'" class="d-flex flex-column ga-2 mt-auto">
  <v-btn
    block color="success" variant="flat"
    class="rounded-lg"
    @click="updateStatus(booking.idDemande, 'ACCEPTEE')"
  >
    <v-icon icon="mdi-check" start size="16"></v-icon>
    Accepter
  </v-btn>
  <v-btn
    block color="error" variant="outlined"
    class="rounded-lg"
    @click="updateStatus(booking.idDemande, 'REFUSEE')"
  >
    <v-icon icon="mdi-close" start size="16"></v-icon>
    Refuser
  </v-btn>
</div>

<v-btn v-else block variant="tonal" color="grey-lighten-4" class="rounded-lg" disabled>
  Demande traitée
</v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-divider class="my-8"></v-divider>

<div class="d-flex align-center justify-space-between mb-6">
  <div>
    <h2 class="text-h5 font-weight-black text-black">Reservations confirmees</h2>
    <p class="text-subtitle-2 text-grey-darken-1">Les demandes acceptees apparaissent ici automatiquement.</p>
  </div>
  <v-chip color="green" variant="tonal" class="font-weight-bold">
    {{ reservations.length }} reservation(s)
  </v-chip>
</div>

<v-row v-if="reservationStore.loading" justify="center" class="py-6">
  <v-progress-circular indeterminate color="primary"></v-progress-circular>
</v-row>

<v-row v-else-if="reservations.length === 0" justify="center" class="py-4">
  <v-col cols="12" md="6" class="text-center">
    <v-alert type="info" variant="tonal">Aucune reservation confirmee pour le moment.</v-alert>
  </v-col>
</v-row>

<v-row v-else>
  <v-col v-for="reservation in reservations" :key="reservation.idReservation" cols="12" md="6" lg="4">
    <v-card border flat class="rounded-xl">
      <v-card-text class="pa-6">
        <div class="d-flex justify-space-between align-start mb-4">
          <div>
            <p class="text-body-2 font-weight-bold mb-0 text-black">Reservation #{{ reservation.idReservation }}</p>
            <h3 class="text-subtitle-1 font-weight-black">{{ reservation.Totalprice }} $</h3>
          </div>
          <v-chip color="green-darken-1" variant="flat" size="small">CONFIRMEE</v-chip>
        </div>

        <div class="d-flex flex-column ga-2">
          <div class="d-flex align-center text-body-2">
            <v-icon icon="mdi-calendar-range" start color="grey" size="18"></v-icon>
            <span>Du <strong>{{ formatDate(reservation.dateDebut) }}</strong></span>
          </div>
          <div class="d-flex align-center text-body-2">
            <v-icon icon="mdi-calendar-check" start color="grey" size="18"></v-icon>
            <span>Au <strong>{{ formatDate(reservation.dateFin) }}</strong></span>
          </div>
        </div>
      </v-card-text>
    </v-card>
  </v-col>
</v-row>

  </v-container>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useDemandeStore } from '@/stores/DemandeStore.js'
import { useUserStore } from '@/stores/UserStore.js'
import { useReservationStore } from '@/stores/ReservationStore.js'

const demandeStore = useDemandeStore()
const userStore = useUserStore()
const reservationStore = useReservationStore()

onMounted(async () => {
  if (userStore.userId) {
    await demandeStore.fetchDemandesBySitter(userStore.userId)
    await reservationStore.fetchConfirmedReservationsByUser(userStore.userId)
  }
})

const bookings = computed(() => demandeStore.demandes)
const reservations = computed(() => reservationStore.confirmedReservation)

const updateStatus = async (id, newStatus) => {
  try {
    await demandeStore.updateStatut(id, newStatus)
    await demandeStore.fetchDemandesBySitter(userStore.userId)
    await reservationStore.fetchConfirmedReservationsByUser(userStore.userId)
  } catch (error) {
    console.error("Erreur lors de la mise a jour :", error)
  }
}

const getStatusColor = (status) => {
  const colors = {
    'EN_ATTENTE': 'orange-darken-2',
    'ACCEPTEE': 'green-darken-1',
    'REFUSEE': 'red-darken-1',
    'ANNULEE': 'grey-darken-1',
    'CONFIRMEE': 'blue-darken-1'
  }
  return colors[status] || 'grey'
}

const formatDate = (dateString) => {
  if (!dateString) return ''

  const [year, month, day] = dateString.split('-').map(Number)
  const localDate = new Date(year, month - 1, day)

  return localDate.toLocaleDateString('fr-CA', {
    day: 'numeric',
    month: 'short',
    year: 'numeric'
  })
}
</script>

<style scoped>
.hover-card {
  transition: transform 0.2s, box-shadow 0.2s;
}
.hover-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px rgba(0,0,0,0.1) !important;
}
</style>
