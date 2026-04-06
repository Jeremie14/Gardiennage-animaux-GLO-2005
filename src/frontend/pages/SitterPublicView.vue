<template>
  <v-container class="py-10">
    <v-row>
      <v-col cols="12" md="8">
        <v-card flat border class="rounded-xl pa-8">
          <div class="d-flex align-center mb-6">
            <v-avatar size="100" class="mr-6 shadow-lg">
              <v-img :src="myProfile.img"></v-img>
            </v-avatar>
            <div>
              <h1 class="text-h4 font-weight-black">{{ myProfile.name }}</h1>
              <v-chip color="amber" variant="flat" size="small">Mode Édition</v-chip>
            </div>
          </div>

          <v-divider class="my-6"></v-divider>

          <h3 class="text-h6 font-weight-bold mb-4">Ma Bio</h3>
          <v-textarea
            v-model="myProfile.description"
            variant="outlined"
            placeholder="Décrivez votre expérience..."
            auto-grow
          ></v-textarea>

          <h3 class="text-h6 font-weight-bold mb-4">Mes Tarifs ($)</h3>
          <v-text-field
            v-model="myProfile.rate"
            type="number"
            prefix="$"
            variant="outlined"
          ></v-text-field>

          <v-btn color="primary" block size="large" class="rounded-xl mt-4">
            Enregistrer les modifications
          </v-btn>
        </v-card>
      </v-col>

      <v-col cols="12" md="4">
        <v-card flat border color="primary" theme="dark" class="rounded-xl pa-6 mb-4">
          <div class="text-overline">Revenus cumulés</div>
          <div class="text-h3 font-weight-bold">120,00 $</div>
          <v-btn variant="tonal" block class="mt-4">Voir les factures</v-btn>
        </v-card>

        <v-card flat border class="rounded-xl pa-6">
          <h3 class="font-weight-bold mb-4">Demandes à venir</h3>
          <v-list density="compact">
            <v-list-item prepend-icon="mdi-calendar" title="Garde de Biscuit" subtitle="12 Avril"></v-list-item>
          </v-list>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'

// This represents the "Logged In" sitter data
const myProfile = ref({
  name: 'Sarah J. (Moi)',
  rate: 45,
  img: 'https://i.pravatar.cc/150?u=1',
  description: "Ceci est ma bio de test. Je m'occupe de vos animaux avec passion !",
  services: ['Promenade', 'Garde à domicile']
})
</script>

