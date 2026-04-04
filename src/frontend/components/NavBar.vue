<template>
  <v-app-bar flat border class="px-0">
    <v-container class="d-flex align-center pa-0">

      <div class="d-flex align-center mr-4">
        <v-icon
          icon="mdi-paw"
          color="primary"
          size="large"
          class="mr-2"
        ></v-icon>

        <v-app-bar-title class="font-weight-black text-primary text-h5 ma-0">
          PawStay
        </v-app-bar-title>
      </div>

      <v-spacer></v-spacer>

      <div class="hidden-sm-and-down">
        <v-btn variant="text" class="text-capitalize text-grey-darken-2">Find a Sitter</v-btn>
        <v-btn variant="text" class="text-capitalize text-grey-darken-2">Become a Sitter</v-btn>
      </div>

      <div class="ml-4 d-flex gap-2">
        <v-btn variant="text" class="text-capitalize rounded-lg" to="/login">Log In</v-btn>
        <v-btn color="primary" variant="flat" class="text-capitalize rounded-lg px-6"
        :to="'/signup'">
          Sign Up
        </v-btn>
      </div>
    </v-container>
  </v-app-bar>
</template>


<style scoped>
.gap-2 {
  gap: 8px;
}
</style>
