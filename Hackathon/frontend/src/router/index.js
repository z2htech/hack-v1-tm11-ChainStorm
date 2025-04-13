import { createRouter, createWebHistory } from "vue-router";

import ModerationView from "../views/Moderation/ModerationView.vue";

import HomeView from "../views/Home/HomeView.vue";

import PostView from "../views/Post/PostView.vue";

import ProfileView from "../views/Profile/ProfileView.vue";

// 定义路由规则
const routes = [
  {
    path: "/",
    name: "Post",
    component: PostView,
  },
  {
    path: "/Post",
    name: "Post",
    component: PostView,
  },
  {
    path: "/Profile",
    name: "Profile",
    component: ProfileView,
  },
  {
    path: "/Moderation",
    name: "Moderation",
    component: ModerationView,
  },
  {
    path: "/Home",
    name: "Home",
    component: HomeView,
  },
];

// 创建路由实例，并指定路由模式（这里使用 HTML5 History 模式）
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
