import { createRouter, createWebHistory } from 'vue-router'
import Home from "@/frontend/pages/Home.vue";
import PetSitter from "@/frontend/pages/PetSitter.vue";
import LoginView from "@/frontend/pages/LoginView.vue";
import SignupView from "@/frontend/pages/SignupView.vue";
import Owner from "@/frontend/pages/Owner.vue";

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
     {
      path: '/owner',
      name: 'owner',
      component: Owner
    },
    ],

})

export default router
