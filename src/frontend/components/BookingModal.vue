<script setup>
import { ref, watch, onMounted } from 'vue'
import { useUserStore } from '@/stores/UserStore.js'
import { useAnimalStore } from '@/stores/AnimalStore.js'
import { useDemandeStore} from "@/stores/DemandeStore.js";
import { useServiceStore} from "@/stores/ServiceStore.js";
import sitterService from '@/service/sitterService.js'

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
  dateDebut.value = ''
  dateFin.value = ''
  selectedAnimal.value = null
  selectedService.value = null
  message.value = ''
  formError.value = ''
  successMessage.value = ''
}

const closeModal = () => {
  resetForm()
  emit('update:modelValue', false)
}

const handleBooking = async () => {
  formError.value = ''
  successMessage.value = ''

  if (!dateDebut.value || !dateFin.value || !selectedAnimal.value || !selectedService.value) {
    formError.value = 'Veuillez remplir tous les champs avant de confirmer.'
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
      message.value
    )
    successMessage.value = 'Votre demande de réservation a été envoyée avec succès.'
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

        <v-row>
          <v-col cols="6">
            <v-text-field
              v-model="dateDebut"
              label="Date de début"
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
  label="Service souhaité"
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
      </v-card-text>

      <v-card-actions>
        <v-btn variant="text" @click="closeModal">Annuler</v-btn>
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          variant="flat"
          size="large"
          class="px-8 rounded-lg"
          :loading="demandeStore.loading"
          @click="handleBooking"
        >
          Confirmer
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
