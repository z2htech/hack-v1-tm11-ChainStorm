<template>
  <div>
    <h1>首</h1>
    <button @click="getData">发送 GET 请求</button>

    <div v-if="loading">中……</div>
    <div v-if="error">发生错误：{{ error.message }}</div>
    <div v-if="data">
      <h2>返回数据：</h2>
      <pre>{{ data }}</pre>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from "vue";
import { useGet } from "../composables/useGet";

const apiURL = "http://127.0.0.1:5000/api/data";
const { data, error, loading, getData } = useGet(apiURL);

// 组件加载时自动发送一次 GET 请求，也可以仅通过按钮点击发送请求
onMounted(() => {
  getData();
});
</script>

<style scoped>
h1 {
  color: #42b983;
}
</style>
