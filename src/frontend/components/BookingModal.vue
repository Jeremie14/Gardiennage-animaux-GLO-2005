<script setup>
const props = defineProps(['modelValue', 'sitter'])
const emit = defineEmits(['update:modelValue'])
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
        <v-row>
          <v-col cols="12">
            <v-text-field label="Date de debut" type="date" variant="outlined"></v-text-field>
          </v-col>
          <v-col cols="12">
            <v-select
              label="Type d'animal"
              :items="['Chien', 'Chat', 'Oiseau', 'Hamster']"
              variant="outlined"
            ></v-select>
          </v-col>
        </v-row>
      </v-card-text>

      <v-card-actions>
        <v-btn variant="text" @click="emit('update:modelValue', false)">Annuler</v-btn>
        <v-spacer></v-spacer>
        <v-btn color="primary" variant="flat" size="large" class="px-8 rounded-lg">
          Confirmer
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>
