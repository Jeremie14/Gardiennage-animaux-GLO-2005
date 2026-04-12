<template>
  <v-card border flat color="grey-lighten-2" class="rounded-xl overflow-hidden h-100 d-flex flex-column">
    <v-img
      :src="sitter.photo || 'https://i.pravatar.cc/150?u=' + sitter.id"
      height="200"
      cover
    ></v-img>

    <v-card-item>
      <div class="d-flex justify-space-between align-center">
        <v-card-title class="font-weight-bold">
          {{ sitter.lastName }} {{sitter.name }}
        </v-card-title>
        <v-chip size="small" color="amber" variant="flat">
          ★ {{ sitter.rating || '5.0' }}
        </v-chip>
      </div>
      <v-card-subtitle class="text-primary font-weight-bold">
        {{ sitter.priceHour}} $ / h
      </v-card-subtitle>
    </v-card-item>

    <v-card-text class="text-body-2 text-grey-darken-1 flex-grow-1">
      {{ sitter.description || 'Aucune description disponible.' }}
    </v-card-text>

    <v-divider></v-divider>

    <v-card-actions class="pa-4">
      <v-btn
        block
        color="primary"
        variant="tonal"
        class="rounded-lg"
        :to="`/sitter/${sitter.id}`"
      >
        Voir le profil
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup>
defineProps(['sitter'])
defineEmits(['book'])
</script>
