<template>
  <div class="user-item">
    <div class="user-avatar">
      <img :src="avatar" :alt="name" />
    </div>
    <div class="user-name">{{ name }}</div>
    <button class="homepage-button" @click="$emit('visit-homepage')">
      Homepage
    </button>
  </div>
</template>

<script setup>
defineProps({
  avatar: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
});

defineEmits(["visit-homepage"]);
</script>

<style scoped>
.user-item {
  display: flex;
  align-items: center;
  padding: 0.8rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 1rem;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.user-name {
  flex: 1;
  font-weight: bold;
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
</style>
