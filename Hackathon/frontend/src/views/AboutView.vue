<template>
  <div>
    <h1>关于</h1>
    <p>欢迎来到关于页面</p>
    <!-- 使用 router-link 返回首页 -->
    <router-link to="/about">返回首页</router-link>
  </div>
</template>

<script setup>
// 可以加入页面特有逻辑
</script>

<style scoped>
h1 {
  color: #35495e;
}
</style>
