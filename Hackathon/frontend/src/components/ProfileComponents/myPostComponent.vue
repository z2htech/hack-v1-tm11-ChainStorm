<template>
  <div class="post-item">
    <div class="post-header">
      <h3 class="post-title">{{ title }}</h3>
      <button class="delete-button" @click="onDelete">Delete</button>
    </div>
    <div class="post-date">{{ time }}</div>
    <p class="post-content">{{ content }}</p>
    <p class="post-tag"># tag</p>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  time: {
    type: String,
    required: true,
  },
});

const emit = defineEmits(["delete"]);

const onDelete = () => {
  emit("delete");
};
</script>

<style scoped>
.post-item {
  padding: 1rem 0;
  border-bottom: 1px solid rgba(180, 41, 255, 0.3);
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.post-title {
  font-size: 1.2rem;
  font-weight: bold;
  color: white;
  margin: 0;
}

.delete-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 20px;
  padding: 0.2rem 0.8rem;
  font-size: 0.8rem;
  cursor: pointer;
}

.post-date {
  color: #ccc;
  font-size: 0.9rem;
  margin: 0.5rem 0;
}

.post-content {
  margin: 0.5rem 0;
  line-height: 1.6;
  color: white;
}

.post-tag {
  color: #b429ff;
  margin: 0.5rem 0 0;
}
</style>
