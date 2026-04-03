<template>
  <v-card border flat color="grey-lighten-2" class="pa-4 rounded-xl">
    <div class="text-subtitle-1 font-weight-bold mb-4">Filters</div>

    <v-label class="mb-2">Services</v-label>
    <v-checkbox label="Dog Walking" density="compact" hide-details color="primary"></v-checkbox>
    <v-checkbox label="House Sitting" density="compact" hide-details color="primary"></v-checkbox>
    <v-checkbox label="Drop-in Visits" density="compact" hide-details color="primary"></v-checkbox>

    <v-divider class="my-4"></v-divider>

    <v-label>Max Price</v-label>
    <v-slider color="primary" thumb-label min="10" max="150" step="5"></v-slider>

    <v-btn block color="primary" class="mt-4 rounded-lg">Apply</v-btn>
  </v-card>
</template>
