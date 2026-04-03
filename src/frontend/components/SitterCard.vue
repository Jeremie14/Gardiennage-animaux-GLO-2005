<script setup>
defineProps(['sitter'])
defineEmits(['book'])
</script>

<template>
  <v-card order flatb color="grey-lighten-2" class="rounded-xl overflow-hidden">
    <v-img :src="sitter.img" height="200" cover></v-img>

    <v-card-item>
      <div class="d-flex justify-space-between align-center">
        <v-card-title class="font-weight-bold">{{ sitter.name }}</v-card-title>
        <v-chip size="small" color="amber" variant="flat">
          ★ {{ sitter.rating }}
        </v-chip>
      </div>
      <v-card-subtitle>${{ sitter.rate }} / night</v-card-subtitle>
    </v-card-item>

    <v-card-text class="text-body-2 text-grey-darken-1">
      {{ sitter.bio }}
    </v-card-text>

    <v-divider></v-divider>

    <v-card-actions  class="pa-4">
      <v-btn
        block
        color="primary"
        variant="tonal"
        class="rounded-lg"
        :to="`/sitter/${sitter.id}`"
      >
        View Profile
      </v-btn>
    </v-card-actions>
  </v-card>
</template>
