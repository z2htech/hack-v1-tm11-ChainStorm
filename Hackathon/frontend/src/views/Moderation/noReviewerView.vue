<template>
  <div class="moderation-page">
    <!-- Navigation Bar Component -->
    <NavigationBar />

    <!-- Main Content Area -->
    <div class="main-content">
      <div class="restriction-container">
        <!-- Close Icon -->
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

        <!-- Apologies Message -->
        <h1 class="restriction-title">APOLOGIES!</h1>
        <h2 class="restriction-subtitle">
          YOU ARE NOT CURRENTLY AUTHORIZED AS A REVIEWER.
        </h2>

        <!-- Divider -->
        <div class="divider"></div>

        <!-- Application Message -->
        <p class="restriction-message">
          Feel free to submit your application here
        </p>

        <!-- Apply Button -->
        <button class="apply-button" @click="showApplyModal = true">
          Apply
        </button>
      </div>
    </div>

    <!-- Apply Modal -->
    <div
      class="modal-overlay"
      v-if="showApplyModal"
      @click.self="showApplyModal = false"
    >
      <div class="modal">
        <div class="modal-header">
          <h2>Reviewer Application</h2>
          <button class="close-modal-button" @click="showApplyModal = false">
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
            <label for="reason">Why do you want to be a reviewer?</label>
            <textarea
              id="reason"
              v-model="applicationForm.reason"
              class="form-textarea"
              rows="4"
              placeholder="Please explain why you want to be a reviewer..."
            ></textarea>
          </div>

          <div class="form-group">
            <label for="experience">Relevant experience:</label>
            <textarea
              id="experience"
              v-model="applicationForm.experience"
              class="form-textarea"
              rows="4"
              placeholder="Please describe any relevant experience..."
            ></textarea>
          </div>

          <div class="form-group">
            <label for="tokens">Tokens to stake:</label>
            <input
              type="number"
              id="tokens"
              v-model="applicationForm.tokens"
              class="form-input"
              min="100"
              placeholder="Minimum 100 tokens"
            />
            <p class="form-help">
              Minimum 100 tokens required to become a reviewer
            </p>
          </div>
        </div>

        <div class="modal-footer">
          <button class="cancel-button" @click="showApplyModal = false">
            Cancel
          </button>
          <button class="submit-button" @click="submitApplication">
            Submit Application
          </button>
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
        <h2>Application Submitted</h2>
        <p>Your application has been submitted successfully!</p>
        <p>We will review your application and get back to you soon.</p>
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
import { ref, reactive } from "vue";
import NavigationBar from "../../components/NavigationBar.vue";
import useContentReviewDAO from "../../composables/useContentReviewDAO";

// Modal state
const showApplyModal = ref(false);
const showSuccessModal = ref(false);

// Application form data
const applicationForm = reactive({
  reason: "",
  experience: "",
  tokens: 100,
});

// Submit application function
const submitApplication = () => {
  const dao = useContentReviewDAO();
  if (!dao) {
    console.error("Web3 初始化失败");
    return;
  }
  const account = dao.getAccount();
  if (!account) {
    console.error("未连接钱包");
    return;
  }
  dao.applyForReviewer();
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
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 2rem;
}

.restriction-container {
  max-width: 800px;
  width: 100%;
  text-align: center;
  border: 1px solid #b429ff;
  border-radius: 10px;
  padding: 3rem 2rem;
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
  font-size: 3rem;
  color: #b429ff;
  margin-bottom: 1rem;
  letter-spacing: 2px;
}

.restriction-subtitle {
  font-size: 2rem;
  color: #b429ff;
  margin-bottom: 2rem;
  letter-spacing: 1px;
  line-height: 1.4;
}

.divider {
  height: 1px;
  background-color: #b429ff;
  margin: 2rem auto;
  width: 80%;
}

.restriction-message {
  font-size: 1.2rem;
  margin-bottom: 2rem;
}

.apply-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 20px;
  padding: 0.5rem 3rem;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.apply-button:hover {
  background-color: rgba(180, 41, 255, 0.1);
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

.form-textarea,
.form-input {
  width: 100%;
  padding: 0.8rem;
  border: 1px solid rgba(180, 41, 255, 0.3);
  border-radius: 5px;
  background-color: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1rem;
  resize: vertical;
}

.form-help {
  font-size: 0.8rem;
  color: #ccc;
  margin-top: 0.5rem;
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

.success-modal p {
  margin-bottom: 1rem;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .restriction-title {
    font-size: 2rem;
  }

  .restriction-subtitle {
    font-size: 1.5rem;
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
