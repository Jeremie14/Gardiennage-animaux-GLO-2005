<template>
  <v-card border flat color="grey-lighten-2" class="pa-4 rounded-xl">
    <div class="text-subtitle-1 font-weight-bold mb-4">Filtres</div>

    <v-label class="mb-2">Services</v-label>
    <v-checkbox label="Promenade" density="compact" hide-details color="primary"></v-checkbox>
    <v-checkbox label="Garde a domicile" density="compact" hide-details color="primary"></v-checkbox>
    <v-checkbox label="Visites ponctuelles" density="compact" hide-details color="primary"></v-checkbox>

    <v-divider class="my-4"></v-divider>

    <v-label>Prix maximal</v-label>
    <v-slider color="primary" thumb-label min="10" max="150" step="5"></v-slider>

    <v-btn block color="primary" class="mt-4 rounded-lg">Appliquer</v-btn>
  </v-card>
</template>
