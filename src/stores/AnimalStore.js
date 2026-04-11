import { defineStore } from 'pinia'
import animalService from '@/service/animalService'

export const useAnimalStore = defineStore('animal', {
  state: () => ({
    animals: [],
    loading: false,
    error: null,
  }),

  getters: {
    animalCount: (state) => state.animals.length,
  },

  actions: {
    async fetchAnimals(ownerId) {
      this.loading = true
      this.error = null
      try {
        this.animals = await animalService.getAnimalsByOwner(ownerId)
      } catch (err) {
        this.error = 'Erreur lors du chargement des animaux.'
        console.error(err)
      } finally {
        this.loading = false
      }
    },

    async addAnimal(animalData) {
      this.error = null
      try {
        await animalService.createAnimal(
          animalData.nom,
          animalData.espece,
          animalData.race,
          animalData.age,
          animalData.poids,
          animalData.idProprietaire,
          animalData.sexe,
          animalData.temperament,
          animalData.besoinsSpeciaux
        )
        await this.fetchAnimals(animalData.idProprietaire)
      } catch (err) {
        this.error = "Erreur lors de l'ajout de l'animal."
        console.error(err)
        throw err
      }
    },

    async removeAnimal(animalId, ownerId) {
      this.error = null
      try {
        await animalService.deleteAnimal(animalId)
        await this.fetchAnimals(ownerId)
      } catch (err) {
        this.error = "Erreur lors de la suppression de l'animal."
        console.error(err)
        throw err
      }
    },
    async updateAnimalPic(animalId, picture) {
      this.error = null
      try {
        await animalService.updateAnimalPic(animalId, picture)
        const animal = this.animals.find(a => a.idAnimal === animalId)
        if (animal) animal.picture = picture
      } catch (err) {
        this.error = "Erreur lors de la mise à jour de la photo."
        console.error(err)
        throw err
      }
    },
  }
})
