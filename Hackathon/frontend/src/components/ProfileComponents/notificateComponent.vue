<template>
  <div class="notification-item">
    <div class="notification-header">
      <div class="notification-icon" :class="type">
        <!-- Comment Icon -->
        <svg
          v-if="type === 'comment'"
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
          <path
            d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"
          ></path>
        </svg>

        <!-- Like Icon -->
        <svg
          v-if="type === 'like'"
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="#b429ff"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path
            d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
          ></path>
        </svg>

        <!-- Collect Icon -->
        <svg
          v-if="type === 'collect'"
          xmlns="http://www.w3.org/2000/svg"
          width="20"
          height="20"
          viewBox="0 0 24 24"
          fill="#b429ff"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <polygon
            points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"
          ></polygon>
        </svg>

        <!-- Reward Icon -->
        <svg
          v-if="type === 'reward'"
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
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
      </div>

      <div class="notification-avatar">
        <img :src="avatar" alt="User Avatar" />
      </div>
    </div>

    <div class="notification-content">
      <div class="notification-text">{{ content }}</div>
      <div v-if="comment" class="notification-comment">{{ comment }}</div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  type: {
    type: String,
    required: true,
    validator: (value) =>
      ["comment", "like", "collect", "reward"].includes(value),
  },
  avatar: {
    type: String,
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  comment: {
    type: String,
    default: "",
  },
});
</script>

<style scoped>
.notification-item {
  display: flex;
  flex-direction: column;
  padding: 1rem;
  border: 1px solid rgba(180, 41, 255, 0.3);
  border-radius: 10px;
  margin-bottom: 1rem;
}

.notification-header {
  display: flex;
  align-items: center;
  margin-bottom: 0.75rem;
}

.notification-icon {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 0.75rem;
  color: #b429ff;
}

.notification-icon.like,
.notification-icon.collect {
  color: #b429ff;
}

.notification-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
}

.notification-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.notification-content {
  margin-left: 0.5rem;
}

.notification-text {
  margin-bottom: 0.5rem;
}

.notification-comment {
  color: #ccc;
  line-height: 1.4;
  padding: 0.5rem;
  background-color: rgba(255, 255, 255, 0.05);
  border-radius: 5px;
}
</style>
