<template>
  <div class="home-page">
    <!-- Navigation Bar Component -->
    <NavigationBar />

    <!-- Main Content Area -->
    <div class="main-content">
      <!-- Logo and Tagline -->
      <div class="logo-section">
        <div class="logo">
          <img
            src="../../assets/image/Pasted-20250413-110635_pixian_ai.png"
            alt="Background Logo"
            class="logo-image background-logo"
          />
          <img
            src="../../assets/image/image 2@2x.png"
            alt="DSDN Logo"
            class="logo-image overlay-logo"
          />
        </div>
        <img
          src="../../assets/image/A High-Quality Decentralized Knowledge Hub (1)_pixian_ai.png"
          alt="A High-Quality Decentralized Knowledge Hub"
          class="tagline"
        />
      </div>

      <!-- Search Bar -->
      <div class="search-container">
        <div class="search-bar">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="search-icon"
          >
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input
            type="text"
            class="search-input"
            placeholder="Start Consensus..."
            v-model="searchQuery"
            @keyup.enter="handleSearch"
          />
        </div>
      </div>

      <!-- Tab Navigation -->
      <div class="tab-navigation">
        <button
          class="tab-button"
          :class="{ active: activeTab === 'featured' }"
          @click="setActiveTab('featured')"
        >
          Featured Blogs
        </button>
        <button
          class="tab-button"
          :class="{ active: activeTab === 'knowledge' }"
          @click="setActiveTab('knowledge')"
        >
          Knowledge Graph
        </button>
      </div>

      <!-- Featured Blogs Content -->
      <div v-if="activeTab === 'featured'" class="content-container">
        <div class="featured-blogs">
          <div class="featured-header">
            <div class="star-icon">
              <img
                src="../../assets/image/jiangbei.png"
                alt="奖杯图标"
                width="50"
                height="50"
              />
            </div>
            <h2 class="featured-title">Featured Blogs</h2>
          </div>

          <div class="blog-list">
            <div
              v-for="(blog, index) in featuredBlogs"
              :key="index"
              class="blog-item"
            >
              <div class="timeline-connector">
                <div
                  class="timeline-line"
                  :class="{ 'last-line': index === featuredBlogs.length - 1 }"
                ></div>
              </div>
              <div class="blog-content">
                <div class="author-info">
                  <div class="author-avatar">
                    <img :src="blog.authorAvatar" :alt="blog.author" />
                  </div>
                  <div class="author-name">{{ blog.author }}</div>
                </div>
                <div class="blog-title">{{ blog.title }}</div>
                <div class="blog-body">{{ blog.content }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Knowledge Graph Content -->
      <div v-if="activeTab === 'knowledge'" class="content-container">
        <div class="knowledge-graph">
          <div class="knowledge-header">
            <div class="graph-icon">
              <img
                src="../../assets/image/ai.png"
                alt="ai图谱图标"
                width="50"
                height="50"
              />
            </div>
            <h2 class="knowledge-title">Knowledge Graph</h2>
          </div>

          <div class="graph-items">
            <div
              v-for="(item, index) in knowledgeItems"
              :key="index"
              class="graph-item"
              @click="showKnowledgeDetail(item)"
            >
              <div class="item-logo">
                <img :src="item.logo" :alt="item.name" />
              </div>
              <div class="item-name">{{ item.name }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Knowledge Detail Modal -->
    <div class="modal-overlay" v-if="showModal" @click.self="closeModal">
      <div class="knowledge-modal">
        <button class="close-button" @click="closeModal">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <line x1="18" y1="6" x2="6" y2="18"></line>
            <line x1="6" y1="6" x2="18" y2="18"></line>
          </svg>
        </button>

        <div class="modal-header">
          <div class="modal-logo">
            <img :src="selectedItem.logo" :alt="selectedItem.name" />
          </div>
          <h2 class="modal-title">{{ selectedItem.name }}</h2>
        </div>

        <div class="modal-content">
          <p>{{ selectedItem.description }}</p>
        </div>
      </div>
    </div>

    <!-- 固定在右下角的 Coze 聊天组件容器 -->
    <div id="coze-chat-container"></div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import { useRouter } from "vue-router";
import NavigationBar from "../../components/NavigationBar.vue";

// Sample featured blogs data
import author1 from "../../assets/image/author1.png";
import author2 from "../../assets/image/author2.png";
import author3 from "../../assets/image/author3.png";
const featuredBlogs = ref([
  {
    author: "Author1",
    authorAvatar: author1,
    title: "Vue3 中的响应式设计",
    content: "学习了Vue3的ref和reactive，掌握了基本的响应式原理。",
  },
  {
    author: "Author2",
    authorAvatar: author2,
    title: "前端组件化实践",
    content: "今天完成了第一个独立组件封装，体验了props和slots的结合。",
  },
  {
    author: "Author3",
    authorAvatar: author3,
    title: "Vite项目构建心得",
    content: "用Vite搭建项目，开发体验明显快于传统webpack，非常适合快速开发。",
  },
]);

// Sample knowledge graph items
import BTC from "../../assets/image/BTC.png";
import ETH from "../../assets/image/ETH.png";
import Sui from "../../assets/image/Sui.png";
import Aptos from "../../assets/image/Aptos.png";
const knowledgeItems = ref([
  {
    name: "BTC",
    logo: BTC,
    description:
      "Bitcoin is a decentralized digital currency, without a central bank or single administrator, that can be sent from user to user on the peer-to-peer bitcoin network without the need for intermediaries.",
  },
  {
    name: "ETH",
    logo: ETH,
    description:
      "Ethereum is a decentralized, open-source blockchain with smart contract functionality. Ether is the native cryptocurrency of the platform.",
  },
  {
    name: "Sui",
    logo: Sui,
    description:
      "Sui is a layer-1 blockchain designed to enable creators and developers to build experiences that cater to the next billion users in web3.",
  },
  {
    name: "Aptos",
    logo: Aptos,
    description:
      "Aptos is a layer 1 blockchain built with Move, a safe and reliable language providing a secure foundation for the web3 ecosystem.",
  },
]);

// Router for page navigation and search
const router = useRouter();
const activeTab = ref("featured");
const searchQuery = ref("");
const showModal = ref(false);
const selectedItem = reactive({
  name: "",
  logo: "",
  description: "",
});

// Function to set active tab
const setActiveTab = (tab) => {
  activeTab.value = tab;
};

// Function to handle search
const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({
      name: "search",
      query: { q: searchQuery.value },
    });
  }
};

// Function to show knowledge detail
const showKnowledgeDetail = (item) => {
  selectedItem.name = item.name;
  selectedItem.logo = item.logo;
  selectedItem.description = item.description;
  showModal.value = true;
};

// Function to close modal
const closeModal = () => {
  showModal.value = false;
};

// Coze 聊天组件集成（在右下角显示）
onMounted(() => {
  // 加载 Coze SDK 脚本
  const script = document.createElement("script");
  script.src =
    "https://lf-cdn.coze.cn/obj/unpkg/flow-platform/chat-app-sdk/1.2.0-beta.6/libs/cn/index.js";
  script.onload = () => {
    // 调用 CozeWebSDK 创建 WebChatClient，指定 container 为页面右下角的固定容器
    new window.CozeWebSDK.WebChatClient({
      config: {
        bot_id: "7492681338060111884",
      },
      componentProps: {
        title: "Coze",
      },
      auth: {
        type: "token",
        token:
          "pat_pUf3TkbUC3UvpuOY3yZK5pTcSWfPNDGrfBvgxBBbdUFNjWDqHdeD1QKcv53tBEYH", // 替换为实际 token
        onRefreshToken: function () {
          return "pat_pUf3TkbUC3UvpuOY3yZK5pTcSWfPNDGrfBvgxBBbdUFNjWDqHdeD1QKcv53tBEYH";
        },
      },
      container: "#coze-chat-container", // 指定挂载容器
    });
  };
  document.body.appendChild(script);
});
</script>

<!-- 全局样式（非 scoped） -->
<style>
@font-face {
  font-family: "SFProDisplayMedium";
  src: url("@/assets/fonts/SFProDisplayMedium.woff2") format("woff2"),
    url("@/assets/fonts/SFProDisplayMedium.woff") format("woff");
  font-weight: normal;
  font-style: normal;
}

html,
body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
  box-sizing: border-box;
}
</style>

<!-- Scoped 样式 -->
<style scoped>
.home-page {
  min-height: 100vh;
  background-color: #0a0118;
  color: white;
  display: flex;
  flex-direction: column;
  margin: 0;
  padding: 0;
}

.main-content {
  flex: 1;
  padding: 0; /* 去除默认内边距 */
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* Logo Section */
.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 2rem;
}

.logo {
  margin-bottom: 1rem;
  position: relative;
  width: 300px;
  height: 300px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 60px;
}

.logo-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.background-logo {
  position: absolute;
  top: 5%;
  left: 50%;
  transform: translate(-50%, 0) scale(2.3);
  z-index: 1;
  opacity: 1;
  pointer-events: none;
}

.overlay-logo {
  position: absolute;
  z-index: 2;
  transform: scale(0.8);
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0% {
    transform: translateY(0px) scale(0.8);
  }
  50% {
    transform: translateY(-10px) scale(0.8);
  }
  100% {
    transform: translateY(0px) scale(0.8);
  }
}

.tagline {
  margin-top: 100px;
  font-size: 2rem;
  font-weight: bold;
  text-align: center;
  color: #b429ff;
  margin: 0;
  letter-spacing: 2px;
  width: 100%;
  max-width: 800px;
}

/* Search Container */
.search-container {
  width: 100%;
  max-width: 500px;
  margin-bottom: 2rem;
}

.search-bar {
  display: flex;
  align-items: center;
  background-color: transparent;
  border: 2px solid #b429ff;
  border-radius: 25px;
  padding: 0.5rem 1rem;
}

.search-icon {
  color: #b429ff;
  margin-right: 0.5rem;
}

.search-input {
  flex: 1;
  background: transparent;
  border: none;
  color: white;
  font-size: 1rem;
  outline: none;
}

/* Tab Navigation */
.tab-navigation {
  display: flex;
  gap: 1rem;
  margin-bottom: 2rem;
}

.tab-button {
  position: relative;
  z-index: 0;
  border: none;
  border-radius: 25px;
  padding: 0.5rem 1.5rem;
  font-size: 1rem;
  color: white;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
}

.tab-button::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 25px;
  padding: 2px;
  background: linear-gradient(
    90deg,
    #5e02c7,
    #7902ce,
    #5a26e8,
    #fcf1fe,
    #df01ea
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  z-index: -1;
}

.tab-button.active::before {
  background: linear-gradient(white, white);
}

.tab-button.active {
  background-color: transparent;
  color: white;
}
.tab-button:hover {
  background-color: rgba(180, 41, 255, 0.1);
}

.tab-button:hover::before {
  filter: brightness(1.2);
}

/* Content Container */
.content-container {
  width: 100%;
  max-width: 800px;
  padding: 1.5rem;
  border-radius: 10px;
  border: 1px solid transparent;
  background: linear-gradient(#0a0118, #0a0118) padding-box,
    linear-gradient(90deg, #5e02c7, #7902ce, #5a26e8, #fcf1fe, #df01ea)
      border-box;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}

/* Featured Blogs Styles */
.featured-header {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
}

.star-icon {
  margin-right: 0.5rem;
}

.featured-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  margin: 0;
}

.blog-list {
  display: flex;
  flex-direction: column;
  max-height: 60vh;
  overflow-y: auto;
}

.blog-item {
  display: flex;
  margin-bottom: 2rem;
  position: relative;
}

.timeline-connector {
  width: 30px;
  position: relative;
}

.timeline-line {
  position: absolute;
  top: 40px;
  bottom: -40px;
  left: 15px;
  width: 2px;
  background-color: #5e02c7;
}

.timeline-line.last-line {
  bottom: 0;
}

.blog-content {
  flex: 1;
}

.author-info {
  display: flex;
  align-items: center;
  margin-bottom: 0.5rem;
}

.author-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
}

.author-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.author-name {
  font-weight: bold;
}

.blog-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: white;
  margin-bottom: 0.5rem;
}

.blog-body {
  font-size: 0.95rem;
  color: #cccccc;
  line-height: 1.6;
}

/* Knowledge Graph Styles */
.knowledge-header {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
}

.graph-icon {
  margin-right: 0.5rem;
}

.knowledge-title {
  font-size: 1.5rem;
  font-weight: bold;
  color: white;
  margin: 0;
}

.graph-items {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  max-height: 60vh;
  overflow-y: auto;
}

.graph-item {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  border-radius: 10px;
  border: 1px solid transparent;
  background: linear-gradient(#0a0118, #0a0118) padding-box,
    linear-gradient(
        90deg,
        #df01ea 0%,
        #5e02c7 25%,
        #0a0118 50%,
        #5e02c7 75%,
        #df01ea 100%
      )
      border-box;
  cursor: pointer;
  transition: all 0.3s ease;
}

.graph-item:hover {
  box-shadow: 0 0 15px rgba(223, 1, 234, 0.6), 0 0 30px rgba(223, 1, 234, 0.3);
  transform: translateY(-2px);
}

.item-logo {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.item-logo img {
  width: 80%;
  height: 80%;
  object-fit: contain;
}

.item-name {
  font-size: 1.2rem;
  font-weight: bold;
  color: white;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.knowledge-modal {
  background-color: #0a0118;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 2rem;
  width: 90%;
  max-width: 600px;
  position: relative;
}

.close-button {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  color: #b429ff;
  cursor: pointer;
  padding: 0;
}

.modal-header {
  display: flex;
  align-items: center;
  margin-bottom: 1.5rem;
}

.modal-logo {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
  background-color: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-logo img {
  width: 80%;
  height: 80%;
  object-fit: contain;
}

.modal-title {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
}

.modal-content {
  line-height: 1.6;
}

/* Scrollbar styling */
.blog-list::-webkit-scrollbar,
.graph-items::-webkit-scrollbar {
  width: 6px;
}

.blog-list::-webkit-scrollbar-track,
.graph-items::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.blog-list::-webkit-scrollbar-thumb,
.graph-items::-webkit-scrollbar-thumb {
  background: #b429ff;
  border-radius: 3px;
}

/* 固定右下角 Coze 聊天容器 */
#coze-chat-container {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1100;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .main-content {
    padding: 0;
  }

  .tagline {
    font-size: 1.5rem;
  }

  .tab-navigation {
    flex-direction: column;
    width: 100%;
  }

  .tab-button {
    width: 100%;
  }

  .knowledge-modal {
    width: 95%;
    padding: 1.5rem;
  }
}
</style>
