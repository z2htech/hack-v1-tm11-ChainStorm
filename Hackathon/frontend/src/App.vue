<template>
  <div id="app">
    <!-- 路由视图，内容随当前路由改变 -->
    <router-view />
  </div>
</template>

<script setup>
// 这里也可以添加全局逻辑
</script>

<style>
/* 全局样式 */
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
}
html,
body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}
</style>
