<template>
  <v-card flat border class="pet-card rounded-xl pa-5 h-100">
    <div class="d-flex align-center mb-4">
      <div class="avatar-wrapper mr-4" @click="triggerUpload">
        <input
          ref="fileInput"
          type="file"
          accept="image/*"
          class="d-none"
          @change="handleImageUpload"
        />
        <div class="avatar-circle" :class="{ 'has-image': photoUrl }">
          <img v-if="photoUrl" :src="photoUrl" alt="Pet photo" class="pet-photo" />
          <span v-else class="text-h4">{{ speciesEmoji }}</span>
          <div class="avatar-overlay">
            <v-icon color="white" size="18">mdi-camera</v-icon>
          </div>
        </div>
      </div>

      <div class="flex-grow-1">
        <h3 class="text-h6 font-weight-bold text-white">{{ animal.name }}</h3>
        <p class="text-subtitle-2 text-neutral-400">
          {{ animal.race }} • {{ animal.age }} ans
        </p>
      </div>

      <v-btn
        icon
        variant="text"
        size="small"
        color="error"
        @click.stop="$emit('delete')"
      >
        <v-icon size="18">mdi-delete-outline</v-icon>
      </v-btn>
    </div>

    <div class="d-flex flex-wrap ga-2">
      <v-chip variant="flat" color="indigo-lighten-5" size="small" class="font-weight-medium rounded-lg">
        {{ animal.species }}
      </v-chip>
      <v-chip v-if="animal.sexe" variant="flat" color="indigo-lighten-5" size="small" class="font-weight-medium rounded-lg">
        {{ animal.sexe }}
      </v-chip>
      <v-chip v-if="animal.temperament" variant="flat" color="amber-lighten-5" size="small" class="font-weight-medium rounded-lg">
        {{ animal.temper }}
      </v-chip>
      <v-chip v-if="animal.besoinsSpeciaux" variant="flat" color="red-lighten-5" size="small" class="font-weight-medium rounded-lg">
        {{ animal.specialNeeds }}
      </v-chip>
    </div>
  </v-card>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  animal: {
    type: Object,
    required: true
  }
})

defineEmits(['delete'])

const fileInput = ref(null)
const photoUrl = ref(null)

const speciesEmoji = computed(() => {
  const map = { chien: '🐕', chat: '🐈', lapin: '🐇', oiseau: '🐦', furet: '🦡', hamster: '🐹' }
  return map[props.animal.species?.toLowerCase()] ?? '🐾'
})

function triggerUpload() {
  fileInput.value?.click()
}

function handleImageUpload(event) {
  const file = event.target.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = (e) => {
    photoUrl.value = e.target.result
  }
  reader.readAsDataURL(file)
}
</script>

<style scoped>
.pet-card {
  background-color: #1A1A1A !important;
  border-color: #333333 !important;
}
.text-neutral-400 { color: #A3A3A3 !important; }

.avatar-wrapper {
  flex-shrink: 0;
  cursor: pointer;
}

.avatar-circle {
  position: relative;
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background-color: #262626;
  border: 2px solid #333333;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  transition: border-color 0.2s ease;
}

.avatar-circle:hover { border-color: #666666; }
.avatar-circle:hover .avatar-overlay { opacity: 1; }

.pet-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.55);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.avatar-circle:not(.has-image) .avatar-overlay { opacity: 0; }
.avatar-circle:not(.has-image):hover .avatar-overlay { opacity: 1; }
</style>
