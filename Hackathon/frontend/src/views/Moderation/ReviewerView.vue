<template>
  <div class="reviewer-dashboard">
    <!-- Navigation Bar Component -->
    <NavigationBar />

    <!-- Main Content Area -->
    <div v-if="activeView === 'dashboard'" class="main-content">
      <!-- Welcome Section -->
      <div class="welcome-section">
        <div class="crown-icon">
          <img
            src="../../assets/image/author2.png"
            alt="Crown"
            class="crown-img"
          />
        </div>
        <h1 class="welcome-text">WELCOME BACK, REVIEWER!</h1>
      </div>

      <!-- Stake Tokens Section -->
      <div class="action-section">
        <button class="stake-button" @click="showStakeModal = true">
          Stake tokens
        </button>
      </div>

      <!-- Review Posts Section -->
      <div class="review-section">
        <h2 class="review-heading">
          There's <span class="post-count">{{ pendingPostsCount }}</span> posts
          waiting for you to review!
        </h2>
        <button class="review-button" @click="activeView = 'reviewPosts'">
          Review Posts
        </button>
      </div>

      <!-- Voting Section -->
      <div class="voting-section">
        <h2 class="voting-heading">
          Auditor elections are live! You've earned your voting rights — don't
          miss the chance to vote!
        </h2>
        <button class="voting-button" @click="activeView = 'voting'">
          Participate In Voting
        </button>
      </div>
    </div>

    <!-- Review Posts View -->
    <div v-if="activeView === 'reviewPosts'" class="content-container">
      <!-- Back Button -->
      <button class="back-button" @click="activeView = 'dashboard'">
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

      <div class="posts-container">
        <div class="posts-list">
          <PostItem
            v-for="(post, index) in noreleaseContens"
            :key="index"
            :title="post.title"
            :content="post.content"
            :time="post.time"
            @delete="reviewPost(post, index)"
          />
        </div>
      </div>
    </div>

    <!-- Post Detail Review View -->
    <div v-if="activeView === 'postDetail'" class="content-container">
      <!-- Back Button -->
      <button class="back-button" @click="activeView = 'reviewPosts'">
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

      <div class="post-detail-container">
        <div class="post-detail-content">
          <div v-html="currentPost.content"></div>
        </div>

        <div class="post-actions">
          <button class="pass-button" @click="passFunction(currentPostIndex)">
            PASS
          </button>
          <button
            class="reject-button"
            @click="rejectFunction(currentPostIndex)"
          >
            REJECT
          </button>
        </div>
      </div>
    </div>

    <!-- Voting View -->
    <div v-if="activeView === 'voting'" class="content-container">
      <!-- Back Button -->
      <button class="back-button" @click="activeView = 'dashboard'">
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

      <div class="voting-container">
        <div class="voting-header">
          <div class="participant-header">Participant</div>
          <div class="staked-header">Staked Token Amount</div>
          <div class="info-header">Information</div>
          <div class="option-header">Option</div>
        </div>

        <div class="voting-list">
          <div v-for="(voter, index) in voters" :key="index" class="voter-item">
            <div class="voter-info">
              <div class="voter-avatar">
                <img :src="voter.avatar" :alt="voter.id" />
              </div>
              <div class="voter-id">{{ voter.id }}</div>
            </div>

            <div class="voter-tokens">{{ voter.tokens }} Tokens</div>

            <div class="voter-info-link">
              <button class="homepage-button" @click="visitHomepage(voter.id)">
                Homepage
              </button>
            </div>

            <div class="voter-options">
              <button
                class="approve-button"
                :class="{ active: voter.isApproved === true }"
                @click="approveVoter(index)"
              >
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
                >
                  <path d="M20 6L9 17l-5-5" />
                </svg>
              </button>

              <button
                class="reject-button"
                :class="{ active: voter.isApproved === false }"
                @click="rejectVoter(index)"
              >
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
                >
                  <circle cx="12" cy="12" r="10" />
                  <line x1="4.93" y1="4.93" x2="19.07" y2="19.07" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Stake Modal -->
    <div
      class="modal-overlay"
      v-if="showStakeModal"
      @click.self="showStakeModal = false"
    >
      <div class="modal">
        <div class="modal-header">
          <h2>Stake Tokens</h2>
          <button class="close-modal-button" @click="showStakeModal = false">
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
        </div>

        <div class="modal-content">
          <div class="form-group">
            <label for="stakeAmount">Amount to stake:</label>
            <input
              type="number"
              id="stakeAmount"
              v-model="stakeAmount"
              class="form-input"
              min="100"
              placeholder="Enter amount"
            />
            <p class="form-help">Minimum 100 tokens required</p>
          </div>

          <div class="token-balance">
            <p>
              Your current balance: <span>{{ userTokens }}</span> Tokens
            </p>
          </div>
        </div>

        <div class="modal-footer">
          <button class="cancel-button" @click="showStakeModal = false">
            Cancel
          </button>
          <button class="submit-button" @click="stakeTokens">Stake</button>
        </div>
      </div>
    </div>

    <!-- Success Modal -->
    <div
      class="modal-overlay"
      v-if="showSuccessModal"
      @click.self="showSuccessModal = false"
    >
      <div class="modal success-modal">
        <h2>Tokens Staked Successfully</h2>
        <p>You have successfully staked {{ stakeAmount }} tokens.</p>
        <div class="modal-footer centered">
          <button class="submit-button" @click="showSuccessModal = false">
            OK
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from "vue";
import NavigationBar from "../../components/NavigationBar.vue";
import PostItem from "../../components/ProfileComponents/myPostComponent.vue";
import useContentReviewDAO from "../../composables/useContentReviewDAO";
import useContentManager from "../../composables/useContentManager";
import useAuthorManager from "../../composables/useAuthorManager";

// View state
const activeView = ref("dashboard"); // 'dashboard', 'reviewPosts', 'postDetail', 'voting'

// Modal states
const showStakeModal = ref(false);
const showSuccessModal = ref(false);

// User data
const userTokens = ref(1000);
const stakeAmount = ref(100);
const pendingPostsCount = ref(3);

// Current post being reviewed
const currentPost = ref({});
const currentPostIndex = ref(null);

const releaseContens = ref([]);
const noreleaseContens = ref([]);
const pendingApplications = ref([]);
const allPendingApplicationDetail = ref([]);

// Voters data
const voters = ref([]);

onMounted(async () => {
  const dao = useContentReviewDAO();
  const author = useAuthorManager();
  const content = useContentManager();

  if (!dao && !content && !author) {
    console.error("Web3 初始化失败");
    return;
  }

  try {
    const account = await author.getAccount();
    if (!account) {
      console.error("未连接钱包");
      return;
    }

    // Fetch content
    const releaseContenIDs = await content.getReleasedArticleIds();
    const noreleaseContenIDS = await content.getUnreleasedArticleIds();
    releaseContens.value = [];
    noreleaseContens.value = [];

    for (let i = 0; i < releaseContenIDs.length; i++) {
      const articleDetail = await content.getArticleDetails(
        releaseContenIDs[i]
      );
      releaseContens.value.push({
        title: "Topic",
        time: "2025-4-12 10:56",
        content: articleDetail[1],
      });
    }

    for (let i = 0; i < noreleaseContenIDS.length; i++) {
      const articleDetail = await content.getArticleDetails(
        noreleaseContenIDS[i]
      );
      noreleaseContens.value.push({
        title: "Topic",
        time: "2025-4-12 10:56",
        content: articleDetail[1],
      });
    }

    // Update pending posts count
    pendingPostsCount.value = noreleaseContens.value.length;

    // Fetch DAO applications
    const pendingApplicationIDs = await dao.getApplicationQueue();
    voters.value = []; // Clear existing voters

    for (let i = 0; i < pendingApplicationIDs.length; i++) {
      const pendingApplicationDetail = await dao.getApplicationDetails(
        pendingApplicationIDs[i]
      );
      const pendingApplicationID = await author.getAuthorIdByAddress(
        pendingApplicationIDs[i]
      );
      voters.value.push({
        avatar: "/avatar-placeholder.png",
        id: pendingApplicationID,
        tokens: 10, // Example token amount, adjust as needed
        isApproved: null,
      });
    }
  } catch (error) {
    console.error("获取作者信息失败:", error);
  }
});

// Functions
const stakeTokens = () => {
  if (stakeAmount.value <= 0) {
    alert("Please enter a valid amount");
    return;
  }

  if (stakeAmount.value > userTokens.value) {
    alert("You don't have enough tokens");
    return;
  }

  userTokens.value -= stakeAmount.value;
  showStakeModal.value = false;
  showSuccessModal.value = true;
};

const reviewPost = (post, index) => {
  console.log("Reviewing post:", post);
  currentPost.value = post;
  currentPostIndex.value = index;
  activeView.value = "postDetail";
};

const passFunction = async (index) => {
  try {
    console.log("Passing post at index:", index);
    // Here you would implement the logic to pass the post
    // For example:
    // await contentManager.approveArticle(articleId);

    // After successful approval, return to the review posts list
    activeView.value = "reviewPosts";

    // Optionally remove the post from the list or update its status
    noreleaseContens.value.splice(index, 1);
    pendingPostsCount.value = noreleaseContens.value.length;
  } catch (error) {
    console.error("Error passing post:", error);
  }
};

const rejectFunction = async (index) => {
  try {
    console.log("Rejecting post at index:", index);
    // Here you would implement the logic to reject the post
    // For example:
    // await contentManager.rejectArticle(articleId);

    // After successful rejection, return to the review posts list
    activeView.value = "reviewPosts";

    // Optionally remove the post from the list or update its status
    noreleaseContens.value.splice(index, 1);
    pendingPostsCount.value = noreleaseContens.value.length;
  } catch (error) {
    console.error("Error rejecting post:", error);
  }
};

const approveVoter = (index) => {
  voters.value[index].isApproved = true;
};

const rejectVoter = (index) => {
  voters.value[index].isApproved = false;
};

const visitHomepage = (id) => {
  console.log("Visit homepage of user:", id);
  // Implement navigation to user homepage
};
</script>

<style scoped>
.reviewer-dashboard {
  min-height: 100vh;
  background-color: #0a0118;
  color: white;
  display: flex;
  flex-direction: column;
}

.main-content,
.content-container {
  flex: 1;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  min-height: calc(100vh - 80px); /* Adjust based on your navbar height */
}

/* Welcome Section */
.welcome-section {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.crown-icon {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.crown-img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
}

.welcome-text {
  font-size: 2.5rem;
  color: #b429ff;
  margin: 0;
}

/* Action Sections */
.action-section,
.review-section,
.voting-section {
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.stake-button,
.review-button,
.voting-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 30px;
  padding: 0.8rem 3rem;
  font-size: 1.2rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.stake-button:hover,
.review-button:hover,
.voting-button:hover {
  background-color: rgba(180, 41, 255, 0.1);
}

.review-heading,
.voting-heading {
  font-size: 1.8rem;
  margin-bottom: 2rem;
}

.post-count {
  font-size: 3rem;
  color: #b429ff;
}

/* Back Button */
.back-button {
  background: none;
  border: none;
  color: #b429ff;
  font-size: 2rem;
  cursor: pointer;
  padding: 0;
  margin-bottom: 1rem;
  align-self: flex-start;
}

/* Posts Container */
.posts-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 1rem;
  flex: 1;
  width: 100%;
}

.posts-list {
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 1rem;
}

/* Post Detail Container */
.post-detail-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 1rem;
  flex: 1;
  width: 100%;
  display: flex;
  flex-direction: column;
}

.post-detail-content {
  flex: 1;
  padding: 1rem;
  overflow-y: auto;
  max-height: 70vh;
  line-height: 1.6;
}

.post-actions {
  display: flex;
  justify-content: space-between;
  padding: 1rem;
  margin-top: 1rem;
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

/* Voting Container */
.voting-container {
  max-width: 900px;
  margin: 0 auto;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 1rem;
  flex: 1;
  width: 100%;
}

.voting-header {
  display: flex;
  padding: 1rem 0;
  border-bottom: 1px solid #b429ff;
  font-weight: bold;
  font-size: 1.2rem;
}

.participant-header {
  flex: 1;
}

.staked-header {
  flex: 1;
  text-align: center;
}

.info-header {
  flex: 1;
  text-align: center;
}

.option-header {
  flex: 1;
  text-align: center;
}

.voting-list {
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 1rem;
}

.voter-item {
  display: flex;
  align-items: center;
  padding: 1rem 0;
  border-bottom: 1px solid rgba(180, 41, 255, 0.3);
}

.voter-info {
  flex: 1;
  display: flex;
  align-items: center;
}

.voter-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
}

.voter-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.voter-id {
  font-weight: bold;
}

.voter-tokens {
  flex: 1;
  text-align: center;
  font-weight: bold;
}

.voter-info-link {
  flex: 1;
  text-align: center;
}

.homepage-button {
  background-color: #b429ff;
  color: white;
  border: none;
  border-radius: 20px;
  padding: 0.3rem 1rem;
  font-size: 0.8rem;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.homepage-button:hover {
  background-color: #9b00e8;
}

.voter-options {
  flex: 1;
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.approve-button,
.reject-button {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  border: none;
  transition: all 0.2s ease;
}

.approve-button {
  background-color: rgba(0, 255, 0, 0.2);
  color: #00ff00;
}

.approve-button:hover,
.approve-button.active {
  background-color: rgba(0, 255, 0, 0.5);
}

.reject-button {
  background-color: rgba(255, 0, 0, 0.2);
  color: #ff6b6b;
}

.reject-button:hover,
.reject-button.active {
  background-color: rgba(255, 0, 0, 0.5);
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
  width: 90%;
  max-width: 500px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(180, 41, 255, 0.3);
}

.modal-header h2 {
  margin: 0;
  color: #b429ff;
}

.close-modal-button {
  background: none;
  border: none;
  color: #b429ff;
  cursor: pointer;
  padding: 0;
}

.modal-content {
  padding: 1.5rem;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding: 1.5rem;
  border-top: 1px solid rgba(180, 41, 255, 0.3);
}

.modal-footer.centered {
  justify-content: center;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: bold;
}

.form-input {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid rgba(180, 41, 255, 0.3);
  border-radius: 5px;
  background-color: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1rem;
}

.form-help {
  font-size: 0.8rem;
  color: #ccc;
  margin-top: 0.5rem;
}

.token-balance {
  margin-top: 1rem;
  font-size: 0.9rem;
}

.token-balance span {
  font-weight: bold;
  color: #b429ff;
}

.cancel-button,
.submit-button {
  padding: 0.5rem 1.5rem;
  border-radius: 20px;
  cursor: pointer;
  font-size: 1rem;
}

.cancel-button {
  background-color: transparent;
  color: white;
  border: 1px solid white;
}

.submit-button {
  background-color: #b429ff;
  color: white;
  border: none;
}

.success-modal {
  text-align: center;
  padding: 2rem;
}

.success-modal h2 {
  color: #b429ff;
  margin-bottom: 1rem;
}

/* Scrollbar styling */
.posts-list::-webkit-scrollbar,
.voting-list::-webkit-scrollbar,
.post-detail-content::-webkit-scrollbar {
  width: 6px;
}

.posts-list::-webkit-scrollbar-track,
.voting-list::-webkit-scrollbar-track,
.post-detail-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.posts-list::-webkit-scrollbar-thumb,
.voting-list::-webkit-scrollbar-thumb,
.post-detail-content::-webkit-scrollbar-thumb {
  background: #b429ff;
  border-radius: 3px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .welcome-section {
    flex-direction: column;
  }

  .welcome-text {
    font-size: 1.8rem;
    text-align: center;
  }

  .review-heading,
  .voting-heading {
    font-size: 1.5rem;
  }

  .voting-header {
    font-size: 0.9rem;
  }

  .voter-item {
    flex-direction: column;
    gap: 0.5rem;
    padding: 1rem;
  }

  .voter-info,
  .voter-tokens,
  .voter-info-link,
  .voter-options {
    width: 100%;
    text-align: left;
  }

  .voter-options {
    justify-content: flex-start;
  }

  .post-actions {
    flex-direction: column;
    gap: 1rem;
  }

  .pass-button,
  .reject-button {
    width: 100%;
  }

  .modal-footer {
    flex-direction: column;
  }

  .cancel-button,
  .submit-button {
    width: 100%;
  }
}
</style>
