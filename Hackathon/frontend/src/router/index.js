import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/AboutView.vue";
import AboutView from "../views/HomeView.vue";
import ThreeGetRequestsView from "../views/ThreeGetRequests.vue";

// 定义路由规则
const routes = [
  {
    path: "/",
    name: "Home",
    component: HomeView,
  },
  {
    path: "/about",
    name: "About",
    component: AboutView,
  },
  {
    path: "/ThreeGetRequests",
    name: "threeGetRequests",
    component: ThreeGetRequestsView,
  },
];

// 创建路由实例，并指定路由模式（这里使用 HTML5 History 模式）
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
