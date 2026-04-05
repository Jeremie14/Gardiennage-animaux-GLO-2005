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
          <span v-else class="text-h4">{{ animal.species === 'cat' ? '🐈' : '🐕' }}</span>
          <div class="avatar-overlay">
            <v-icon color="white" size="18">mdi-camera</v-icon>
          </div>
        </div>
      </div>

      <div>
        <h3 class="text-h6 font-weight-bold text-white">{{ animal.name }}</h3>
        <p class="text-subtitle-2 text-neutral-400">
          {{ animal.breed }} • {{ animal.age }} ans
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
import { ref } from 'vue'

defineProps({
  animal: {
    type: Object,
    required: true
  }
})

const fileInput = ref(null)
const photoUrl = ref(null)

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

.avatar-circle:hover {
  border-color: #666666;
}

.avatar-circle:hover .avatar-overlay {
  opacity: 1;
}

.pet-photo {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* Camera overlay shown on hover */
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

.avatar-circle:not(.has-image) .avatar-overlay {
  opacity: 0;
}
.avatar-circle:not(.has-image):hover .avatar-overlay {
  opacity: 1;
}

:deep(.v-chip.bg-accent-success) {
  background-color: #213C36 !important;
  color: #A7F3D0 !important;
}
:deep(.v-chip.bg-neutral-700) {
  background-color: #262626 !important;
  color: #FBBF24 !important;
}
</style>
