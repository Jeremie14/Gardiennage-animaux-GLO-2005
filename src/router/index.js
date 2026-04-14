import { createRouter, createWebHistory } from 'vue-router'
import Home from "@/frontend/pages/Home.vue";
import PetSitter from "@/frontend/pages/PetSitter.vue";
import LoginView from "@/frontend/pages/LoginView.vue";
import SignupView from "@/frontend/pages/SignupView.vue";
import Owner from "@/frontend/pages/Owner.vue";
import OwnerPublicView from "@/frontend/pages/OwnerPublicView.vue";
import SitterPublicView from "@/frontend/pages/SitterPublicView.vue";
import SitterBookings from "@/frontend/pages/SitterBookings.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/sitter/:id',
      name: 'sitter-profile',
      component: PetSitter
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupView
    },
    { path: '/owner/dashboard/:id', component: Owner },
    { path: '/sitter/dashboard/:id', component: PetSitter },


    { path: '/owner/:id', component: OwnerPublicView },
    { path: '/sitter/profile/', component: SitterPublicView },
    {
    path: '/sitter/bookings/',
    name: 'SitterBookings',
    component: SitterBookings
  },
    ],

})

export default router
