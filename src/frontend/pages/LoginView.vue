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
            <v-form v-model="isValid" @submit.prevent="handleLogin">
              <v-text-field
                v-model="email"
                label="Email"
                type="email"
                variant="outlined"
                prepend-inner-icon="mdi-email-outline"
                :rules="[v => !!v || 'Email is required']"
                required
              ></v-text-field>

              <v-text-field
                v-model="password"
                label="Password"
                variant="outlined"
                prepend-inner-icon="mdi-lock-outline"
                :type="showPassword ? 'text' : 'password'"
                :append-inner-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                @click:append-inner="showPassword = !showPassword"
                :rules="[v => !!v || 'Password is required']"
                required
              ></v-text-field>

              <v-btn
                type="submit"
                color="primary"
                block
                size="large"
                class="mt-4 rounded-lg font-weight-bold"
                :disabled="!isValid"
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

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const isValid = ref(false)

const handleLogin = () => {
  console.log('Logging in with:', email.value, password.value)
}
</script>
