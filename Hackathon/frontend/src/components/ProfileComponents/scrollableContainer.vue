<template>
  <div class="section-container">
    <div class="section-header">
      <div class="header-icon">
        <slot name="icon"></slot>
      </div>
      <h2 class="section-title">{{ title }}</h2>
    </div>

    <div v-if="showTotal" class="total-count">Total:{{ totalItems }}</div>

    <div class="scrollable-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true,
  },
  totalItems: {
    type: Number,
    default: 0,
  },
  showTotal: {
    type: Boolean,
    default: true,
  },
});
</script>

<style scoped>
.section-container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  border: 1px solid #b429ff;
  border-radius: 10px;
  background-color: #0a0118;
  overflow: hidden;
}

.section-header {
  display: flex;
  align-items: center;
  padding: 1.5rem;
  padding-bottom: 0.5rem;
}

.header-icon {
  color: #b429ff;
  margin-right: 0.5rem;
}

.section-title {
  color: #b429ff;
  font-size: 1.5rem;
  font-weight: bold;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.total-count {
  color: #b429ff;
  padding: 0 1.5rem;
  margin-bottom: 1rem;
}

.scrollable-content {
  flex: 1;
  overflow-y: auto;
  padding: 0 1.5rem 1.5rem;
}

/* Scrollbar styling */
.scrollable-content::-webkit-scrollbar {
  width: 6px;
}

.scrollable-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
}

.scrollable-content::-webkit-scrollbar-thumb {
  background: #b429ff;
  border-radius: 3px;
}
</style>
