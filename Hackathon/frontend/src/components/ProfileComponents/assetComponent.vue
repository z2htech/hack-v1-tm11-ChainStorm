<template>
  <div class="asset-detail-item">
    <div class="asset-info">
      <div class="asset-title">{{ title }}</div>
      <div class="asset-amount" :class="{ negative: amount < 0 }">
        {{ amount > 0 ? "+" : "" }}{{ amount }} Tokens
      </div>
    </div>
    <button class="details-button" @click="onDetailsClick">Details</button>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
});

const emit = defineEmits(["details"]);

const onDetailsClick = () => {
  emit("details");
};
</script>

<style scoped>
.asset-detail-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1.5rem;
}

.asset-info {
  display: flex;
  flex-direction: column;
}

.asset-title {
  color: #b429ff;
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.asset-amount {
  color: white;
  font-weight: bold;
  font-size: 1.1rem;
}

.asset-amount.negative {
  color: #ff6b6b;
}

.details-button {
  background-color: transparent;
  color: #b429ff;
  border: 1px solid #b429ff;
  border-radius: 20px;
  padding: 0.2rem 0.8rem;
  font-size: 0.8rem;
  cursor: pointer;
}
</style>
