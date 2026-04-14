<script setup>
import { ref, watch, onMounted, computed } from 'vue'
import { useUserStore } from '@/stores/UserStore.js'
import { useAnimalStore } from '@/stores/AnimalStore.js'
import { useDemandeStore} from "@/stores/DemandeStore.js";
import { useServiceStore} from "@/stores/ServiceStore.js";
import sitterService from '@/service/sitterService.js'

const step = ref(1)
const bookingHours = ref('1')

const cardName = ref('')
const cardNumber = ref('')
const expiryDate = ref('')
const cvv = ref('')
const paymentMethod = ref('Crédit')

const totalPrice = computed(() => {
  const priceHour = Number(props.sitter?.priceHour || 0)
  const hours = normalizedBookingHours.value
  return priceHour * hours
})

const normalizedBookingHours = computed(() => {
  const value = Number.parseInt(bookingHours.value, 10)
  return Number.isNaN(value) || value < 1 ? 1 : value
})


const props = defineProps(['modelValue', 'sitter'])
const emit = defineEmits(['update:modelValue'])

const userStore = useUserStore()
const animalStore = useAnimalStore()
const demandeStore = useDemandeStore()
const serviceStore = useServiceStore()


const dateDebut = ref('')
const dateFin = ref('')
const selectedAnimal = ref(null)
const selectedService = ref(null)
const message = ref('')
const services = ref([])
const formError = ref('')
const successMessage = ref('')

onMounted(async () => {
  if (userStore.userId) {
    await animalStore.fetchAnimals(userStore.userId)
  }
})

const loadServices = async (sitterId) => {
  await serviceStore.fetchServicesBySitter(sitterId)
}

watch(() => props.sitter, (sitter) => {
  if (sitter?.id) loadServices(sitter.id)
}, { immediate: true })

const clearMessages = () => {
  formError.value = ''
  successMessage.value = ''
}

const resetForm = () => {
  step.value = 1
  dateDebut.value = ''
  dateFin.value = ''
  bookingHours.value = 1
  selectedAnimal.value = null
  selectedService.value = null
  message.value = ''
  cardName.value = ''
  cardNumber.value = ''
  expiryDate.value = ''
  cvv.value = ''
  paymentMethod.value = 'Crédit'
  formError.value = ''
  successMessage.value = ''
}

const closeModal = () => {
  resetForm()
  emit('update:modelValue', false)
}

const goToPaymentStep = () => {
  formError.value = ''
  successMessage.value = ''

  if (!dateDebut.value || !dateFin.value || !selectedAnimal.value || !selectedService.value) {
    formError.value = 'Veuillez remplir les informations de reservation avant de continuer.'
    return
  }

  if (!bookingHours.value || Number(bookingHours.value) <= 0) {
    formError.value = "Le nombre d'heures doit etre superieur a 0."
    return
  }

  step.value = 2
}

const handleBooking = async () => {
  formError.value = ''
  successMessage.value = ''

  if (!cardName.value || !cardNumber.value || !expiryDate.value || !cvv.value) {
    formError.value = 'Veuillez remplir toutes les informations de paiement.'
    return
  }

  try {
    await demandeStore.createDemande(
      userStore.userId,
      props.sitter.id,
      selectedAnimal.value,
      selectedService.value,
      dateDebut.value,
      dateFin.value,
      message.value,
      normalizedBookingHours.value
    )

    successMessage.value = 'Votre demande de reservation a ete envoyee avec succes.'
  } catch (e) {
    formError.value = "Erreur lors de l'envoi de la demande."
  }
}

</script>

<template>
  <v-dialog
    :model-value="modelValue"
    @update:model-value="val => emit('update:modelValue', val)"
    max-width="540"
  >
    <v-card class="rounded-xl pa-4" v-if="sitter">
      <v-card-title class="text-h5 font-weight-bold mb-2">
        Réserver avec {{ sitter.name }}
      </v-card-title>

      <v-card-text>
        <v-alert v-if="formError" type="error" variant="tonal" class="mb-4">{{ formError }}</v-alert>
        <v-alert v-if="successMessage" type="success" variant="tonal" class="mb-4">{{ successMessage }}</v-alert>

        <v-window v-model="step">
          <v-window-item :value="1">
            <v-row>
              <v-col cols="6">
                <v-text-field
                  v-model="dateDebut"
                  label="Date de debut"
                  type="date"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="6">
                <v-text-field
                  v-model="dateFin"
                  label="Date de fin"
                  type="date"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-text-field
                  v-model="bookingHours"
                  label="Nombre d'heures"
                  type="number"
                  min="1"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-select
                  v-model="selectedAnimal"
                  label="Mon animal"
                  :items="animalStore.animals.map(a => ({ title: a.name, value: a.idAnimal }))"
                  item-title="title"
                  item-value="value"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-select>
              </v-col>

              <v-col cols="12">
                <v-select
                  v-model="selectedService"
                  label="Service souhaite"
                  :items="serviceStore.services.map(s => ({ title: s.typeService, value: s.idService }))"
                  item-title="title"
                  item-value="value"
                  variant="outlined"
                  density="comfortable"
                  :loading="serviceStore.loading"
                  :no-data-text="'Aucun service disponible'"
                  @update:model-value="clearMessages"
                ></v-select>
              </v-col>

              <v-col cols="12">
                <v-textarea
                  v-model="message"
                  label="Message (optionnel)"
                  variant="outlined"
                  density="comfortable"
                  rows="3"
                ></v-textarea>
              </v-col>
            </v-row>
          </v-window-item>

          <v-window-item :value="2">
            <div class="mb-4">
              <div class="text-subtitle-1 font-weight-bold">Resume du paiement</div>
              <div class="text-body-2 text-grey-darken-1">
                Taux horaire : {{ props.sitter.priceHour }} $ / h
              </div>
              <div class="text-body-2 text-grey-darken-1">
                Nombre d'heures : {{ normalizedBookingHours }}
              </div>
              <div class="text-h6 font-weight-black mt-2">
                Total : {{ totalPrice }} $
              </div>
            </div>

            <v-row>
              <v-col cols="12">
                <v-text-field
                  v-model="cardName"
                  label="Nom sur la carte"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-text-field
                  v-model="cardNumber"
                  label="Numero de carte"
                  variant="outlined"
                  density="comfortable"
                  maxlength="16"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="6">
                <v-text-field
                  v-model="expiryDate"
                  label="Date d'expiration"
                  placeholder="MM/AA"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="6">
                <v-text-field
                  v-model="cvv"
                  label="CVV"
                  variant="outlined"
                  density="comfortable"
                  maxlength="4"
                  @update:model-value="clearMessages"
                ></v-text-field>
              </v-col>

              <v-col cols="12">
                <v-select
                  v-model="paymentMethod"
                  label="Methode de paiement"
                  :items="['Crédit', 'Débit']"
                  variant="outlined"
                  density="comfortable"
                  @update:model-value="clearMessages"
                ></v-select>
              </v-col>
            </v-row>
          </v-window-item>
        </v-window>
      </v-card-text>

      <v-card-actions>
        <v-btn variant="text" @click="closeModal">Annuler</v-btn>
        <v-spacer></v-spacer>

        <v-btn
          v-if="step === 2"
          variant="text"
          @click="step = 1"
        >
          Retour
        </v-btn>

        <v-btn
          v-if="step === 1"
          color="primary"
          variant="flat"
          size="large"
          class="px-8 rounded-lg"
          @click="goToPaymentStep"
        >
          Continuer vers le paiement
        </v-btn>

        <v-btn
          v-else
          color="primary"
          variant="flat"
          size="large"
          class="px-8 rounded-lg"
          :loading="demandeStore.loading"
          @click="handleBooking"
        >
          Payer et envoyer
        </v-btn>
      </v-card-actions>

    </v-card>
  </v-dialog>
</template>
