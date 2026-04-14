<template>
  <v-container class="fill-height" fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="4">
        <v-card class="pa-6 rounded-xl" elevation="2">
          <v-card-item class="text-center">
            <v-icon icon="mdi-paw" color="primary" size="large" class="mb-2"></v-icon>
            <v-card-title class="text-h5 font-weight-bold">Connexion</v-card-title>
            <v-card-subtitle>Connectez-vous pour gérer vos gardes d'animaux</v-card-subtitle>
          </v-card-item>

          <v-card-text>
            <v-alert
              v-if="formError || userStore.error"
              type="error"
              variant="tonal"
              class="mb-4"
            >
              {{ formError || userStore.error }}
            </v-alert>

            <v-form v-model="isValid" @submit.prevent="handleLogin">
              <v-text-field
                v-model="email"
                label="Courriel"
                type="email"
                variant="outlined"
                prepend-inner-icon="mdi-email-outline"
                :rules="emailRules"
                :disabled="userStore.loading"
                @update:model-value="clearFormError"
                required
              ></v-text-field>

              <v-text-field
                v-model="password"
                label="Mot de passe"
                variant="outlined"
                prepend-inner-icon="mdi-lock-outline"
                :type="showPassword ? 'text' : 'password'"
                :append-inner-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                @click:append-inner="showPassword = !showPassword"
                :rules="passwordRules"
                :disabled="userStore.loading"
                @update:model-value="clearFormError"
                required
              ></v-text-field>

              <v-btn
                color="primary"
                block
                size="large"
                class="mt-4 rounded-lg font-weight-bold"
                type="submit"
                :loading="userStore.loading"
                :disabled="!isValid || userStore.loading"
              >
                Connexion
              </v-btn>
            </v-form>
          </v-card-text>

          <v-card-actions class="justify-center">
            <span class="text-body-2">Vous n'avez pas encore de compte ?</span>
            <v-btn variant="text" color="primary" to="/signup" class="text-none">Inscription</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore} from "@/stores/UserStore.js";

const router = useRouter()
const userStore = useUserStore()

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const isValid = ref(false)
const formError = ref('')

const emailRules = [
  (v) => !!v || 'Le courriel est obligatoire',
  (v) => /.+@.+\..+/.test(v || '') || 'Le courriel doit être valide',
]

const passwordRules = [
  (v) => !!v || 'Le mot de passe est obligatoire',
  (v) => (v || '').length >= 8 || 'Le mot de passe doit contenir au moins 8 caractères',
]

const clearFormError = () => {
  formError.value = ''
  userStore.error = null
}

const handleLogin = async () => {
  if (!isValid.value) return

  formError.value = ''

  try {
    const success = await userStore.login(email.value, password.value)

    if (success) {
      if (userStore.userRole === 'Gardien') {
        await router.push('/sitter/bookings')
      } else {
        router.push('/')
      }
    }
  } catch (error) {
    console.error("Échec de la connexion", error)
  }
}
</script>
