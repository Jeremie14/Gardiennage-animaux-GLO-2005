<template>
  <v-container class="fill-height" fluid>
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="4">
        <v-card class="pa-6 rounded-xl" elevation="2">
          <v-card-item class="text-center">
            <v-icon icon="mdi-paw" color="primary" size="large" class="mb-2"></v-icon>
            <v-card-title class="text-h5 font-weight-bold">Welcome Back</v-card-title>
            <v-card-subtitle>Log in to manage your pet sittings</v-card-subtitle>
          </v-card-item>

          <v-card-text>
            <v-alert
              v-if="formError"
              type="error"
              variant="tonal"
              class="mb-4"
            >
              {{ formError }}
            </v-alert>

            <v-form v-model="isValid" @submit.prevent="handleLogin">
              <v-text-field
                v-model="email"
                label="Email"
                type="email"
                variant="outlined"
                prepend-inner-icon="mdi-email-outline"
                :rules="emailRules"
                :disabled="isSubmitting"
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
                :disabled="isSubmitting"
                @update:model-value="clearFormError"
                required
              ></v-text-field>

              <v-btn
                type="submit"
                color="primary"
                block
                size="large"
                class="mt-4 rounded-lg font-weight-bold"
                :disabled="!isValid || isSubmitting"
                :loading="isSubmitting"
              >
                Log In
              </v-btn>
            </v-form>
          </v-card-text>

          <v-card-actions class="justify-center">
            <span class="text-body-2">Don't have an account?</span>
            <v-btn variant="text" color="primary" to="/signup" class="text-none">Sign Up</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const isValid = ref(null)
const isSubmitting = ref(false)
const formError = ref('')

const emailRules = [
  (v) => !!v || 'Le courriel est obligatoire',
  (v) => /.+@.+\..+/.test(v || '') || 'Le courriel doit etre valide',
]

const passwordRules = [
  (v) => !!v || 'Le mot de passe est obligatoire',
  (v) => (v || '').length >= 8 || 'Le mot de passe doit contenir au moins 8 caracteres',
]

const clearFormError = () => {
  formError.value = ''
}

const handleLogin = async () => {
  formError.value = ''

  if (!email.value || !password.value) {
    formError.value = 'Veuillez remplir tous les champs.'
    return
  }

  if (!/.+@.+\..+/.test(email.value)) {
    formError.value = 'Le courriel doit etre valide.'
    return
  }

  if (password.value.length < 8) {
    formError.value = 'Le mot de passe doit contenir au moins 8 caracteres.'
    return
  }

  isSubmitting.value = true

  try {
    await new Promise((resolve) => setTimeout(resolve, 800))

    const validEmail = 'client@pawstay.com'
    const validPassword = 'motdepasse123'

    if (email.value !== validEmail || password.value !== validPassword) {
      formError.value = 'Adresse courriel ou mot de passe incorrect.'
      return
    }

    router.push('/owner')
  } catch (error) {
    formError.value = 'Une erreur est survenue. Veuillez reessayer.'
  } finally {
    isSubmitting.value = false
  }
}
</script>
