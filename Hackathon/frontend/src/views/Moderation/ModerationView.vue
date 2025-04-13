<template>
  <div class="moderation-page">
    <!-- Navigation Bar Component -->
    <NavigationBar />

    <!-- Main Content Area -->
    <div class="main-content">
      <!-- Back Button -->
      <button class="back-button" @click="goBack">
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
          <path d="m15 18-6-6 6-6" />
        </svg>
      </button>

      <!-- Post List View (shown when not viewing a specific post) -->
      <div v-if="!currentPost && !showRestrictionPage" class="posts-container">
        <div class="posts-list">
          <div v-for="(post, index) in posts" :key="index" class="post-item">
            <div class="post-header">
              <h2 class="post-title">{{ post.title }}</h2>
              <button class="review-button" @click="reviewPost(post)">
                Review
              </button>
            </div>
            <div class="post-date">{{ post.date }}</div>
            <div class="post-content">{{ post.content }}</div>
            <div class="post-tag">{{ post.tag }}</div>
            <div class="divider" v-if="index !== posts.length - 1"></div>
          </div>
        </div>
      </div>

      <!-- Post Detail View (shown when reviewing a specific post) -->
      <div
        v-if="currentPost && !showRestrictionPage"
        class="post-detail-container"
      >
        <div class="post-detail">
          <div class="post-detail-content">
            <h2 class="post-detail-title">{{ currentPost.title }}</h2>
            <div
              class="post-detail-text"
              v-html="currentPost.fullContent"
            ></div>
          </div>
          <div class="post-actions">
            <button class="pass-button" @click="showPassModal = true">
              PASS
            </button>
            <button class="reject-button" @click="showRestrictionPage = true">
              REJECT
            </button>
          </div>
        </div>
      </div>

      <!-- Restriction Page (shown when Reject is clicked) -->
      <div v-if="showRestrictionPage" class="restriction-container">
        <div class="restriction-content">
          <div class="close-icon">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="64"
              height="64"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M3 3h18v18H3z" />
              <path d="M3 8h18" />
              <path d="M8 3v18" />
            </svg>
            <div class="close-text">CLOSE</div>
          </div>

          <h1 class="restriction-title">APOLOGIES!</h1>
          <h2 class="restriction-subtitle">
            YOU ARE NOT CURRENTLY AUTHORIZED AS A REVIEWER.
          </h2>

          <div class="divider"></div>

          <p class="restriction-message">
            Feel free to submit your application here
          </p>

          <button class="apply-button" @click="showApplySuccessModal = true">
            Apply
          </button>
        </div>
      </div>
    </div>

    <!-- Pass Modal -->
    <div
      class="modal-overlay"
      v-if="showPassModal"
      @click.self="showPassModal = false"
    >
      <div class="modal">
        <h2>Confirm Pass</h2>
        <p>Are you sure you want to approve this post?</p>
        <div class="modal-actions">
          <button class="cancel-button" @click="showPassModal = false">
            Cancel
          </button>
          <button class="confirm-button" @click="confirmPass">Confirm</button>
        </div>
      </div>
    </div>

    <!-- Apply Success Modal -->
    <div
      class="modal-overlay"
      v-if="showApplySuccessModal"
      @click.self="showApplySuccessModal = false"
    >
      <div class="modal">
        <h2>Application Submitted</h2>
        <p>Your application has been submitted successfully!</p>
        <div class="modal-actions">
          <button class="confirm-button" @click="closeApplySuccessModal">
            OK
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from "vue";
import NavigationBar from "../../components/NavigationBar.vue";
import useContentReviewDAO from "../../composables/useContentReviewDAO";

// State variables
const currentPost = ref(null);
const showPassModal = ref(false);
const showRestrictionPage = ref(false);
const showApplySuccessModal = ref(false);

onMounted(async () => {
  const author = useAuthorManager();

  const content = useContentManager();

  if (!author && !content) {
    console.error("Web3 初始化失败");
    return;
  }

  try {
    const account = await author.getAccount();
    if (!account) {
      console.error("未连接钱包");
      return;
    }
  } catch (error) {
    console.error("获取DAO1信息失败:", error);
  }
});

// Sample posts data
const posts = ref([
  {
    id: 1,
    title: "Topic",
    date: "2025-4-12 10:56",
    content:
      "Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction",
    tag: "# tag",
    fullContent: `
      <h3>### **Bitcoin Products Tailored for Institutional Demand**</h3> of Bitcoin ETFs as proof of market demand, calling them "the most successful product launch in financial industry history." He argued that while institutional investors are constrained by volatility, risk-seeking players crave leverage—a gap his firm aims to bridge:</p>
    `,
  },
  {
    id: 2,
    title: "Topic",
    date: "2025-4-12 10:56",
    content:
      "Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction",
    tag: "# tag",
    fullContent: `
      <h3>### **Bitcoin Products Tailored for Institutional Demand**</h3>
      <p>Rochard explained that the company's target clients include **credit allocators seeking volatility protection** and **equity risk-takers pursuing Bitcoin's asymmetric upside**. Market conditions permitting, its long-term vision involves securing $1 trillion in BTC over the next 21 years.</p>
      
      <p>When asked about the timing and motivation behind the launch, Rochard revealed that the concept of a Bitcoin-backed securitization firm had intrigued him since his early days in Bitcoin, aligning with his background in asset-backed finance.</p>
    `,
  },
  {
    id: 3,
    title: "Topic",
    date: "2025-4-12 10:56",
    content:
      "Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction Brief introduction",
    tag: "# tag",
    fullContent: `
      <h3>### **Validation from Bitcoin ETF Success**</h3>
      <p>Rochard highlighted the explosive success of Bitcoin ETFs as proof of market demand, calling them "the most successful product launch in financial industry history." He argued that while institutional investors are constrained by volatility, risk-seeking players crave leverage—a gap his firm aims to bridge:</p>
      <p>> "The Bitcoin Bond Company exists to responsibly connect these two groups through Bitcoin-backed products, creating long-term value for both."</p>
    `,
  },
]);

// Function to review a post
const reviewPost = (post) => {
  currentPost.value = post;
};

// Function to go back to post list
const goBack = () => {
  currentPost.value = null;
  showRestrictionPage.value = false;
};

// Function to confirm pass
const confirmPass = () => {
  // Here you would implement the logic to approve the post
  showPassModal.value = false;
  currentPost.value = null; // Go back to post list
};

// Function to close apply success modal
const closeApplySuccessModal = () => {
  showApplySuccessModal.value = false;
  showRestrictionPage.value = false;
  currentPost.value = null; // Go back to post list
};
</script>

<style scoped>
.moderation-page {
  min-height: 100vh;
  background-color: #0a0118;
  color: white;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  padding: 1rem 2rem;
  position: relative;
}

.back-button {
  background: none;
  border: none;
  color: #b429ff;
  font-size: 2rem;
  cursor: pointer;
  padding: 0;
  margin-bottom: 1rem;
}

/* Posts List Styles */
.posts-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 1rem;
}

.posts-list {
  max-height: calc(100vh - 200px);
  overflow-y: auto;
}

.post-item {
  padding: 1.5rem 0;
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.post-title {
  font-size: 1.5rem;
  margin: 0;
}

.post-date {
  color: #ccc;
  margin-bottom: 0.5rem;
}

.post-content {
  margin-bottom: 0.5rem;
  line-height: 1.5;
}

.post-tag {
  color: #b429ff;
  margin-bottom: 0.5rem;
}

.review-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 20px;
  padding: 0.3rem 1rem;
  font-size: 0.9rem;
  cursor: pointer;
}

.divider {
  height: 1px;
  background-color: #b429ff;
  margin: 1rem 0 0 0;
}

/* Post Detail Styles */
.post-detail-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 1rem;
}

.post-detail {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 200px);
}

.post-detail-content {
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
}

.post-detail-title {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}

.post-detail-text {
  line-height: 1.6;
}

.post-detail-text h3 {
  color: white;
  margin-top: 1.5rem;
  margin-bottom: 1rem;
}

.post-detail-text p {
  margin-bottom: 1rem;
}

.post-actions {
  display: flex;
  justify-content: space-between;
  padding: 1rem;
}

.pass-button,
.reject-button {
  width: 48%;
  padding: 1rem;
  border: none;
  border-radius: 10px;
  font-size: 1.5rem;
  font-weight: bold;
  cursor: pointer;
  text-transform: uppercase;
}

.pass-button {
  background-color: #b429ff;
  color: #00ff00;
}

.reject-button {
  background-color: #b429ff;
  color: #ff6b6b;
}

/* Restriction Page Styles */
.restriction-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 2rem;
  text-align: center;
  height: calc(100vh - 200px);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.restriction-content {
  max-width: 600px;
}

.close-icon {
  margin-bottom: 2rem;
  color: #b429ff;
}

.close-text {
  font-size: 1.2rem;
  font-weight: bold;
  margin-top: 0.5rem;
}

.restriction-title {
  font-size: 2.5rem;
  color: #b429ff;
  margin-bottom: 1rem;
}

.restriction-subtitle {
  font-size: 2rem;
  color: #b429ff;
  margin-bottom: 2rem;
}

.restriction-message {
  font-size: 1.2rem;
  margin-top: 2rem;
  margin-bottom: 2rem;
}

.apply-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 20px;
  padding: 0.5rem 2rem;
  font-size: 1rem;
  cursor: pointer;
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

.modal {
  background-color: #0a0118;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 2rem;
  width: 90%;
  max-width: 400px;
  text-align: center;
}

.modal h2 {
  margin-bottom: 1rem;
}

.modal p {
  margin-bottom: 2rem;
}

.modal-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.cancel-button,
.confirm-button {
  padding: 0.5rem 1.5rem;
  border-radius: 20px;
  cursor: pointer;
}

.cancel-button {
  background-color: transparent;
  color: white;
  border: 1px solid white;
}

.confirm-button {
  background-color: #b429ff;
  color: white;
  border: none;
}

/* Scrollbar styling */
.posts-list::-webkit-scrollbar,
.post-detail-content::-webkit-scrollbar {
  width: 6px;
}

.posts-list::-webkit-scrollbar-track,
.post-detail-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.posts-list::-webkit-scrollbar-thumb,
.post-detail-content::-webkit-scrollbar-thumb {
  background: #b429ff;
  border-radius: 3px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .main-content {
    padding: 1rem;
  }

  .post-actions {
    flex-direction: column;
    gap: 1rem;
  }

  .pass-button,
  .reject-button {
    width: 100%;
  }

  .restriction-title {
    font-size: 2rem;
  }

  .restriction-subtitle {
    font-size: 1.5rem;
  }
}
</style>
