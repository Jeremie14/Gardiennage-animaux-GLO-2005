<script setup>
import { ref } from 'vue'

defineProps(['modelValue', 'sitter'])
const emit = defineEmits(['update:modelValue'])

const bookingDate = ref('')
const petType = ref('')
const formError = ref('')
const successMessage = ref('')

const clearMessages = () => {
  formError.value = ''
  successMessage.value = ''
}

const resetForm = () => {
  bookingDate.value = ''
  petType.value = ''
  formError.value = ''
  successMessage.value = ''
}

const closeModal = () => {
  resetForm()
  emit('update:modelValue', false)
}

const handleBooking = () => {
  formError.value = ''
  successMessage.value = ''

  if (!bookingDate.value || !petType.value) {
    formError.value = 'Veuillez remplir tous les champs avant de confirmer.'
    return
  }

  successMessage.value = 'Votre demande de reservation a ete envoyee avec succes.'
}
</script>

<template>
  <v-dialog
    :model-value="modelValue"
    @update:model-value="val => emit('update:modelValue', val)"
    max-width="500"
  >
    <v-card class="rounded-xl pa-4" v-if="sitter">
      <v-card-title class="text-h5 font-weight-bold">
        Reserver avec {{ sitter.name }}
      </v-card-title>

      <v-card-text>
        <v-alert
          v-if="formError"
          type="error"
          variant="tonal"
          class="mb-4"
        >
          {{ formError }}
        </v-alert>

        <v-alert
          v-if="successMessage"
          type="success"
          variant="tonal"
          class="mb-4"
        >
          {{ successMessage }}
        </v-alert>

        <v-row>
          <v-col cols="12">
            <v-text-field
              v-model="bookingDate"
              label="Date de debut"
              type="date"
              variant="outlined"
              @update:model-value="clearMessages"
            ></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-select
              v-model="petType"
              label="Type d'animal"
              :items="['Chien', 'Chat', 'Oiseau', 'Hamster']"
              variant="outlined"
              @update:model-value="clearMessages"
            ></v-select>
          </v-col>
        </v-row>
      </v-card-text>

      <v-card-actions>
        <v-btn variant="text" @click="closeModal">Annuler</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="primary" variant="flat" size="large" class="px-8 rounded-lg" @click="handleBooking"> Confirmer</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
