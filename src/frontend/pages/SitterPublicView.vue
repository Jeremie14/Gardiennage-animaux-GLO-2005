<template>
  <v-container class="py-10">
    <v-row v-if="sitterStore.loading" justify="center">
      <v-progress-circular indeterminate color="primary"></v-progress-circular>
    </v-row>

    <v-row v-else>
      <v-col cols="12" md="8">
        <v-card flat border class="rounded-xl pa-8">
          <div class="d-flex align-center mb-6">
            <v-avatar size="100" class="mr-6 shadow-lg">
              <v-img :src="sitterStore.selectedSitter?.img || 'https://i.pravatar.cc/150'"></v-img>
            </v-avatar>
            <div>
              <h1 class="text-h4 font-weight-black">
                {{ userStore.user?.name }} {{ userStore.user?.lastName }}
              </h1>
              <v-chip color="amber" variant="flat" size="small">Mode Édition</v-chip>
            </div>
          </div>

          <v-divider class="my-6"></v-divider>

          <h3 class="text-h6 font-weight-bold mb-4">Ma Bio</h3>
          <v-textarea
            v-model="editForm.description"
            variant="outlined"
            placeholder="Décrivez votre expérience..."
            auto-grow
          ></v-textarea>

          <h3 class="text-h6 font-weight-bold mb-4">Mes Tarifs ($)</h3>
          <v-text-field
            v-model="editForm.tariffJournalier"
            type="number"
            prefix="$"
            variant="outlined"
            label="Tarif par nuit"
          ></v-text-field>

          <v-btn
            color="primary"
            block
            size="large"
            class="rounded-xl mt-4"
            :loading="sitterStore.loading"
            @click="handleSave"
          >
            Enregistrer les modifications
          </v-btn>

          <v-alert v-if="sitterStore.error" type="error" class="mt-4" variant="tonal">
            {{ sitterStore.error }}
          </v-alert>
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
import { ref, onMounted, reactive } from 'vue'
import {useUserStore} from "@/stores/UserStore.js";
import {useSitterStore} from "@/stores/PetSitterStore.js";

const userStore = useUserStore()
const sitterStore = useSitterStore()


const editForm = reactive({
  description: '',
  tariffJournalier: 0,
  experience: 0,
  zoneService: ''
})

onMounted(async () => {
  const userId = userStore.userId
  if (userId) {
    await sitterStore.fetchSitterById(userId)

    // Une fois chargé, on remplit le formulaire avec les données de l'API
    if (sitterStore.selectedSitter) {
      editForm.description = sitterStore.selectedSitter.description || ''
      editForm.tariffJournalier = sitterStore.selectedSitter.tariffJournalier || 0
      editForm.experience = sitterStore.selectedSitter.experience || 0
      editForm.zoneService = sitterStore.selectedSitter.zoneService || ''
    }
  }
})

const handleSave = async () => {
  try {
    await sitterStore.updateSitterProfile(userStore.userId, {
      ...editForm
    })
    alert("Profil mis à jour avec succès !")
  } catch (error) {
    console.error("Erreur lors de la sauvegarde", error)
  }
}
</script>
