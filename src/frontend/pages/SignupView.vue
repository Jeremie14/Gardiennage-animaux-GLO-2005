<template>
  <v-container class="fill-height">
    <v-row justify="center" align="center">
      <v-col cols="12" sm="10" md="6" lg="5">

        <v-card
          :elevation="step === 1 ? 4 : 0"
          :class="[
            'pa-8 rounded-xl transition-all duration-500',
            step === 1 ? 'bg-white border' : 'bg-transparent'
          ]"
          :flat="step === 2"
        >
          <v-alert
              v-if="formError"
              type="error"
              variant="tonal"
              class="mb-4"
            >
              {{ formError }}
          </v-alert>
          <v-window v-model="step">

            <v-window-item :value="1">
              <div class="text-center mb-8">
                <v-icon icon="mdi-paw" color="primary" size="40" class="mb-2"></v-icon>
                <h2 class="text-h4 font-weight-black">Creer un compte</h2>
              </div>

              <v-text-field
                v-model="fullName"
                label="Nom complet"
                variant="outlined"
                color="primary"
                density="comfortable"
                @update:model-value="clearFormError"
              ></v-text-field>

              <v-text-field
                v-model="email"
                label="Courriel"
                variant="outlined"
                color="primary"
                density="comfortable"
                @update:model-value="clearFormError"
              ></v-text-field>

              <v-text-field
                v-model="password"
                label="Mot de passe"
                type="password"
                variant="outlined"
                color="primary"
                density="comfortable"
                @update:model-value="clearFormError"
              ></v-text-field>

              <v-text-field
                v-model="confirmPassword"
                label="Confirmer le mot de passe"
                type="password"
                variant="outlined"
                color="primary"
                density="comfortable"
                @update:model-value="clearFormError"
              ></v-text-field>

              <v-btn
                block
                color="primary"
                size="x-large"
                class="rounded-lg mt-4 font-weight-bold"
                @click="goToStepTwo"
              >
                Suivant
              </v-btn>
            </v-window-item>

            <v-window-item :value="2">
              <div class="text-center mb-10">
                <h2 class="text-h3 font-weight-black mb-2">Je suis...</h2>
                <p class="text-grey-darken-1 text-h6">Selectionnez votre role principal</p>
              </div>

              <v-row justify="center" class="ga-4">
                <v-col cols="12" sm="5">
                  <v-card
                    :variant="selectedRole === 'owner' ? 'flat' : 'outlined'"
                    :color="selectedRole === 'owner' ? 'primary' : 'grey-lighten-1'"
                    class="role-square d-flex flex-column align-center justify-center pa-8 rounded-xl cursor-pointer shadow-sm"
                    @click="selectedRole = 'owner'"
                  >
                    <v-icon icon="mdi-dog" size="64" class="mb-4"></v-icon>
                    <span class="text-h6 font-weight-bold">Proprietaire</span>
                  </v-card>
                </v-col>

                <v-col cols="12" sm="5">
                  <v-card
                    :variant="selectedRole === 'sitter' ? 'flat' : 'outlined'"
                    :color="selectedRole === 'sitter' ? 'primary' : 'grey-lighten-1'"
                    class="role-square d-flex flex-column align-center justify-center pa-8 rounded-xl cursor-pointer shadow-sm"
                    @click="selectedRole = 'sitter'"
                  >
                    <v-icon icon="mdi-briefcase-check" size="64" class="mb-4"></v-icon>
                    <span class="text-h6 font-weight-bold">Gardien</span>
                  </v-card>
                </v-col>
              </v-row>

              <div class="d-flex justify-center align-center mt-12">
                <v-btn variant="text" color="grey-darken-1" class="mr-4" @click="step = 1">
                  Retour
                </v-btn>
                <v-btn
                  color="primary"
                  size="x-large"
                  class="px-12 rounded-pill font-weight-black shadow-lg"
                  :disabled="!selectedRole"
                  @click="finishSignUp"
                >
                  Creer un compte
                </v-btn>
              </div>
            </v-window-item>

          </v-window>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const step = ref(1)
const selectedRole = ref(null)

const fullName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const formError = ref('')

const clearFormError = () => {
  formError.value = ''
}

const goToStepTwo = () => {
  formError.value = ''

  if (!fullName.value || !email.value || !password.value || !confirmPassword.value) {
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

  if (password.value !== confirmPassword.value) {
    formError.value = 'Les mots de passe ne correspondent pas.'
    return
  }

  step.value = 2
}

const finishSignUp = () => {
  formError.value = ''

  if (!selectedRole.value) {
    formError.value = 'Veuillez selectionner un role.'
    return
  }

  router.push('/login')
}
</script>

<style scoped>
.role-square {
  height: 220px;
  transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
  background-color: white !important; /* Keeps the squares visible on transparent background */
}

.role-square:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(0,0,0,0.1) !important;
}

.transition-all {
  transition: all 0.5s ease-in-out;
}

/* Make sure the "Back" button is visible on transparent */
.v-btn--variant-text {
  font-weight: bold;
}
</style>
