<template>
  <div>
    <h1>三个 GET 请求示例</h1>

    <!-- 第一部分：Items -->
    <section>
      <h2>Items</h2>
      <button @click="loadItems">加载 Items</button>
      <div v-if="loadingItems">加载中……</div>
      <div v-if="errorItems">错误：{{ errorItems.message }}</div>
      <!-- 注意这里使用 items.items，因为后端返回的是 { items: [...] } -->
      <ul v-if="items && items.items && items.items.length">
        <li v-for="item in items.items" :key="item.id">
          {{ item.id }} - {{ item.name }}
        </li>
      </ul>
    </section>

    <!-- 第二部分：Users -->
    <section>
      <h2>Users</h2>
      <button @click="loadUsers">加载 Users</button>
      <div v-if="loadingUsers">加载中……</div>
      <div v-if="errorUsers">错误：{{ errorUsers.message }}</div>
      <!-- 注意这里使用 users.users，因为后端返回的是 { users: [...] } -->
      <ul v-if="users && users.users && users.users.length">
        <li v-for="user in users.users" :key="user.id">
          {{ user.id }} - {{ user.username }}
        </li>
      </ul>
    </section>

    <!-- 第三部分：Status -->
    <section>
      <h2>Status</h2>
      <button @click="loadStatus">加载 Status</button>
      <div v-if="loadingStatus">加载中……</div>
      <div v-if="errorStatus">错误：{{ errorStatus.message }}</div>
      <div v-if="status">状态：{{ status.status }} - {{ status.message }}</div>
    </section>
  </div>
</template>

<script setup>
import { useGet } from "../composables/useGet";

// 使用 useGet 分别请求三个 API
const {
  data: items,
  error: errorItems,
  loading: loadingItems,
  getData: getItems,
} = useGet("http://127.0.0.1:5000/api/items");
const {
  data: users,
  error: errorUsers,
  loading: loadingUsers,
  getData: getUsers,
} = useGet("http://127.0.0.1:5000/api/users");
const {
  data: status,
  error: errorStatus,
  loading: loadingStatus,
  getData: getStatus,
} = useGet("http://127.0.0.1:5000/api/status");

// 方法：分别触发请求
const loadItems = () => {
  getItems();
};

const loadUsers = () => {
  getUsers();
};

const loadStatus = () => {
  getStatus();
};
</script>

<style scoped>
section {
  margin-bottom: 20px;
  padding: 16px;
  border: 1px solid #ddd;
}
</style>
