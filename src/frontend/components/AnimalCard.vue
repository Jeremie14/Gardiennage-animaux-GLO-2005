<template>
  <v-card flat border class="pet-card rounded-xl pa-5 h-100">
    <div class="d-flex align-center mb-4">
      <v-avatar size="60" color="neutral-700" class="mr-4">
        <span class="text-h4">{{ animal.species === 'cat' ? '🐈' : '🐕' }}</span>
      </v-avatar>
      <div>
        <h3 class="text-h6 font-weight-bold text-white">{{ animal.name }}</h3>
        <p class="text-subtitle-2 text-neutral-400">
          {{ animal.breed }} • {{ animal.age }} yr
        </p>
      </div>
    </div>

    <div class="d-flex flex-wrap ga-2">
      <v-chip
        v-for="tag in animal.tags"
        :key="tag.text"
        variant="flat"
        :color="tag.color || 'neutral-700'"
        size="small"
        class="font-weight-medium rounded-lg"
      >
        {{ tag.text }}
      </v-chip>
    </div>
  </v-card>
</template>

<script setup>
defineProps({
  animal: {
    type: Object,
    required: true
  }
})
</script>

<style scoped>
.pet-card {
  background-color: #1A1A1A !important;
  border-color: #333333 !important;
}
.text-neutral-400 { color: #A3A3A3 !important; }

/* Custom colors for the specific dashboard look */
:deep(.v-chip.bg-accent-success) {
  background-color: #213C36 !important;
  color: #A7F3D0 !important;
}
:deep(.v-chip.bg-neutral-700) {
  background-color: #262626 !important;
  color: #FBBF24 !important; /* Amber text for 'Indoor only' */
}
</style>
