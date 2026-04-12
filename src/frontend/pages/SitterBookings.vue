<template>
  <v-container class="py-10">
    <header class="mb-8">
      <h1 class="text-h4 font-weight-black">Discussions et reservations</h1>
      <p class="text-grey-darken-1">Retrouvez vos demandes dans une presentation de type messagerie.</p>
    </header>

    <v-row>
      <v-col cols="12">
        <v-row>
          <v-col cols="12" sm="4" v-for="stat in stats" :key="stat.title">
            <v-card flat border class="rounded-xl pa-5 text-center">
              <v-icon :icon="stat.icon" color="primary" size="large" class="mb-2"></v-icon>
              <div class="text-h4 font-weight-black">{{ stat.value }}</div>
              <div class="text-caption text-uppercase text-grey">{{ stat.title }}</div>
            </v-card>
          </v-col>
        </v-row>
      </v-col>

      <v-col cols="12">
        <v-card flat border class="rounded-xl overflow-hidden">
          <v-tabs v-model="tab" bg-color="transparent" color="primary" grow>
            <v-tab value="pending">En attente ({{ pendingBookings.length }})</v-tab>
            <v-tab value="confirmed">Confirmees</v-tab>
            <v-tab value="history">Historique</v-tab>
          </v-tabs>

          <v-window v-model="tab" class="pa-4 bg-grey-lighten-5">
            <v-window-item value="pending">
              <v-alert v-if="pendingBookings.length === 0" type="info" variant="tonal" class="rounded-lg">
                Aucune nouvelle demande pour le moment.
              </v-alert>

              <v-card
                v-for="booking in pendingBookings"
                :key="booking.id"
                flat
                border
                class="conversation-card rounded-xl pa-4 mb-4 bg-white"
              >
                <div class="d-flex align-center flex-wrap ga-4">
                  <v-avatar size="56" color="primary-lighten-4">
                    <v-img v-if="booking.ownerImg" :src="booking.ownerImg"></v-img>
                    <span v-else class="text-h6 text-primary">{{ booking.ownerName.charAt(0) }}</span>
                  </v-avatar>

                  <div class="flex-grow-1">
                    <div class="d-flex align-center justify-space-between flex-wrap ga-2">
                      <div class="font-weight-bold text-h6">{{ booking.ownerName }}</div>
                      <div class="text-caption text-grey-darken-1">{{ booking.time }}</div>
                    </div>
                    <div class="text-body-2 text-grey-darken-1 mb-1">
                      {{ booking.messagePreview }}
                    </div>
                    <div class="text-caption text-grey-darken-1">
                      <v-icon size="small" color="primary">mdi-paw</v-icon>
                      {{ booking.petName }} • {{ booking.date }}
                    </div>
                  </div>

                  <div class="text-right ml-auto">
                    <div class="font-weight-black text-h6 text-primary">{{ booking.price }}$</div>
                    <div class="d-flex ga-2 mt-2 justify-end">
                      <v-btn color="success" variant="flat" size="small" class="rounded-lg" @click="updateStatus(booking.id, 'Confirmed')">Accepter</v-btn>
                      <v-btn color="error" variant="tonal" size="small" class="rounded-lg" @click="updateStatus(booking.id, 'Cancelled')">Refuser</v-btn>
                    </div>
                  </div>
                </div>
              </v-card>
            </v-window-item>

            <v-window-item value="confirmed">
              <v-card
                v-for="booking in confirmedBookings"
                :key="booking.id"
                flat
                border
                class="conversation-card rounded-xl pa-4 mb-4 bg-white border-s-xl border-s-success"
              >
                <div class="d-flex align-center flex-wrap ga-4">
                  <v-avatar size="56" color="success-lighten-5">
                    <v-img v-if="booking.ownerImg" :src="booking.ownerImg"></v-img>
                    <span v-else class="text-h6 text-success">{{ booking.ownerName.charAt(0) }}</span>
                  </v-avatar>

                  <div class="flex-grow-1">
                    <div class="d-flex align-center justify-space-between flex-wrap ga-2">
                      <div class="font-weight-bold">{{ booking.ownerName }} & {{ booking.petName }}</div>
                      <div class="text-caption text-grey">{{ booking.time }}</div>
                    </div>
                    <div class="text-body-2 text-grey-darken-1 mb-1">{{ booking.messagePreview }}</div>
                    <div class="text-caption text-grey">{{ booking.date }}</div>
                  </div>

                  <v-spacer></v-spacer>
                  <v-btn variant="text" icon="mdi-message-outline"></v-btn>
                </div>
              </v-card>
            </v-window-item>

            <v-window-item value="history">
              <v-alert type="info" variant="tonal" class="rounded-lg">
                L'historique complet des discussions sera ajoute ici.
              </v-alert>
            </v-window-item>
          </v-window>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { computed, ref } from 'vue'

const tab = ref('pending')

const stats = [
  { title: 'Revenus total', value: '450$', icon: 'mdi-cash-check' },
  { title: 'Gardes ce mois', value: '8', icon: 'mdi-calendar-heart' },
  { title: 'Note moyenne', value: '4.9', icon: 'mdi-star' },
]

const bookings = ref([
  {
    id: 1,
    ownerName: 'Jean Dupont',
    ownerImg: 'https://i.pravatar.cc/150?u=9',
    petName: 'Rex',
    date: '12-14 avril',
    price: 90,
    status: 'Pending',
    time: 'Il y a 5 min',
    messagePreview: 'Bonjour, je voudrais reserver une garde pour Rex la semaine prochaine.'
  },
  {
    id: 2,
    ownerName: 'Marie Curie',
    ownerImg: '',
    petName: 'Isis',
    date: '18 avril',
    price: 30,
    status: 'Pending',
    time: 'Il y a 20 min',
    messagePreview: 'Bonsoir, est-ce que vous acceptez les chats anxieux pour une visite ponctuelle ?'
  },
  {
    id: 3,
    ownerName: 'Luc Bernard',
    ownerImg: 'https://i.pravatar.cc/150?u=12',
    petName: 'Flash',
    date: '22-25 avril',
    price: 120,
    status: 'Confirmed',
    time: 'Hier',
    messagePreview: 'Merci, la reservation pour Flash est bien confirmee.'
  },
])

const pendingBookings = computed(() => bookings.value.filter((booking) => booking.status === 'Pending'))
const confirmedBookings = computed(() => bookings.value.filter((booking) => booking.status === 'Confirmed'))

const updateStatus = (id, newStatus) => {
  const index = bookings.value.findIndex((booking) => booking.id === id)
  if (index !== -1) {
    bookings.value[index].status = newStatus
  }
}
</script>

<style scoped>
.conversation-card {
  transition: background-color 0.2s ease, transform 0.2s ease;
}

.conversation-card:hover {
  background-color: #f7f8fa !important;
  transform: translateY(-1px);
}
</style>
