<template>
  <div>
    <!-- 原有显示部分保持不变 -->

    <!-- 新增交互操作区 -->
    <div class="actions">
      <div>
        <input v-model="approveAmount" placeholder="授权金额" />
        <input v-model="spenderAddress" placeholder="授权地址" />
        <button @click="handleApprove">授权</button>
      </div>

      <div>
        <input v-model="transferAmount" placeholder="转账金额" />
        <input v-model="transferAddress" placeholder="接收地址" />
        <button @click="handleTransfer">转账</button>
      </div>

      <div>
        <input v-model="transferFromAmount" placeholder="划转金额" />
        <input v-model="fromAddress" placeholder="来源地址" />
        <input v-model="toAddress" placeholder="目标地址" />
        <button @click="handleTransferFrom">代转账</button>
      </div>

      <button @click="fetchTotalSupply">查询总供应量</button>
      <p v-if="totalSupply !== null">总发行量: {{ totalSupply }} KLT</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import useKLT from "../composables/useKLT";

const {
  web3,
  KLTContract,
  getAccount,
  approve,
  transfer,
  transferFrom,
  getTotalSupply,
} = useKLT();

// 响应式数据
const approveAmount = ref("");
const spenderAddress = ref("");
const transferAmount = ref("");
const transferAddress = ref("");
const transferFromAmount = ref("");
const fromAddress = ref("");
const toAddress = ref("");
const totalSupply = ref(null);
const error = ref(null);

// 操作处理函数
const handleApprove = async () => {
  try {
    await approve(spenderAddress.value, approveAmount.value);
    error.value = null;
  } catch (err) {
    error.value = `授权失败: ${err.message}`;
  }
};

const handleTransfer = async () => {
  try {
    await transfer(transferAddress.value, transferAmount.value);
    error.value = null;
  } catch (err) {
    error.value = `转账失败: ${err.message}`;
  }
};

const handleTransferFrom = async () => {
  try {
    await transferFrom(
      fromAddress.value,
      toAddress.value,
      transferFromAmount.value
    );
    error.value = null;
  } catch (err) {
    error.value = `代转账失败: ${err.message}`;
  }
};

const fetchTotalSupply = async () => {
  try {
    totalSupply.value = await getTotalSupply();
    error.value = null;
  } catch (err) {
    error.value = `查询总供应量失败: ${err.message}`;
  }
};
</script>

<style scoped>
.actions div {
  margin: 15px 0;
  padding: 10px;
  border: 1px solid #eee;
}

input {
  margin: 0 5px;
  padding: 5px;
  width: 200px;
}
</style>
