<template>
  <div class="post-page">
    <!-- 导航栏等部分保持不变 -->
    <NavigationBar />

    <main class="main-content">
      <div class="headings">
        <img
          src="../../assets/image/Knowledge.png"
          alt="Knowledge is Value"
          class="heading-image"
        />
      </div>

      <div class="content-container">
        <div class="scrollable-content">
          <textarea
            v-model="postContent"
            class="post-textarea"
            placeholder="Write your post here..."
          ></textarea>
        </div>
      </div>

      <div class="post-button-container">
        <button
          class="post-button"
          @click="handleSubmit"
          :disabled="isPublishing"
        >
          {{ isPublishing ? "Posting..." : "POST" }}
        </button>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { create } from "ipfs-http-client"; // IPFS http 客户端
import NavigationBar from "../../components/NavigationBar.vue";
import useContentManager from "../../composables/useContentManager";

// 创建 IPFS 客户端实例
// 这里的 URL 要根据你服务器 IPFS 的配置来修改
// 例如： http://<你的IP或域名>:5001/api/v0
const ipfs = create({
  url: "http://47.109.154.172:5001/",
});

const { writeArticle } = useContentManager();

const isPublishing = ref(false);
const postContent = ref(
  `Dare to share your voice—every story matters! Publish your words and inspire the world!`
);

const contentManager = useContentManager();
// 上传到 IPFS 的辅助函数
async function uploadToIPFS(content) {
  try {
    // 将要上传的内容包装成对象
    const file = {
      path: "post.txt",
      content: content,
    };

    // ipfs.add 支持传入一个文件或数组，这里直接传单个对象
    const { cid } = await ipfs.add(file);

    const lastNumber = await contentManager.getArticleCount();
    const lastNumberAsNumber = Number(lastNumber);
    console.log("当前文章数量:", lastNumberAsNumber);

    // 更新合约中的文章 IPFS 哈希（转换后的 bytes32 数据）
    await contentManager.updateArticleIPFS(lastNumberAsNumber, cid.toString());

    // 也可以返回字符串形式，方便后续写合约或前端展示
    return cid.toString();
  } catch (err) {
    console.error("IPFS 上传失败:", err);
    throw new Error("IPFS 上传失败");
  }
}

const handleSubmit = async () => {
  try {
    isPublishing.value = true;

    // 第一步：上传到 IPFS
    const ipfsHash = await uploadToIPFS(postContent.value);
    console.log("IPFS 返回的哈希:", ipfsHash);

    // 第二步：将文章内容（或哈希）提交到智能合约
    // 如果你希望只把 content 存 IPFS，上链只存 ipfsHash，可以把 writeArticle 改成:
    // await writeArticle(ipfsHash)
    // 这样合约里就能存储 IPFS 哈希，而不是纯文本
    await writeArticle(postContent.value);

    postContent.value = "";
    // 如果需要刷新文章列表，可在此调用 loadArticles()
    // await loadArticles();
  } catch (error) {
    alert(error.message || "发布失败");
  } finally {
    isPublishing.value = false;
  }
};
</script>
<style scoped>
.post-page {
  min-height: 100vh;
  height: 100vh; /* Fixed height to prevent page scrolling */
  background-color: #0a0118;
  color: white;
  display: flex;
  flex-direction: column;
  overflow: hidden; /* Prevent page scrolling */
}

/* Main Content 样式 */
.main-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 1rem;
  flex: 1;
  overflow: hidden;
}

.headings {
  text-align: center;
  margin-bottom: 2rem;
}

.heading-primary {
  font-size: 1.5rem;
  color: #b429ff;
  font-weight: bold;
  margin-bottom: 0.5rem;
  letter-spacing: 0.05em;
}

.heading-secondary {
  font-size: 1.5rem;
  color: white;
  font-weight: bold;
  letter-spacing: 0.05em;
}

.content-container {
  width: 100%;
  max-width: 48rem;
  border: 1px solid transparent; /* Keep border transparent for the gradient to show */
  border-radius: 0.5rem;
  margin-bottom: 2rem;
  height: 60vh;
  overflow: hidden;

  /* Apply gradient border */
  background: linear-gradient(#0a0118, #0a0118) padding-box,
    linear-gradient(90deg, #5e02c7, #7902ce, #5a26e8, #fcf1fe, #df01ea)
      border-box;

  /* Optional: Glassmorphism effect with backdrop blur */
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}

.scrollable-content {
  height: 100%;
  overflow-y: auto; /* Enable vertical scrolling */
  padding: 0.5rem;
}

.scrollable-content::-webkit-scrollbar {
  width: 8px;
}

.scrollable-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.scrollable-content::-webkit-scrollbar-thumb {
  background: #df01ea;
  border-radius: 4px;
}

.post-textarea {
  width: 100%;
  height: 200%;
  background-color: transparent;
  border: none;
  color: white;
  padding: 1rem;
  outline: none;
  resize: none; /* Prevent manual resizing */
  font-family: inherit;
  line-height: 1.6;
  font-size: 0.95rem;
}

.post-textarea::placeholder {
  color: #6b7280;
}

.post-button-container {
  width: 100%;
  max-width: 20rem;
}

.post-button {
  width: 100%;
  height: 4rem;
  background: url("../../assets/image/button1.png") no-repeat center center;
  background-size: contain;
  color: white;
  border: none;
  border-radius: 0.5rem;
  padding: 1rem 2rem;
  font-size: 1.5rem;
  font-weight: bold;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  cursor: pointer;
  position: relative;
  transition: background-color 0.2s, box-shadow 0.2s, transform 0.1s;
  display: flex;
  align-items: center;
  justify-content: center;

  /* 默认浮起阴影，立体感 */
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.35);
}

.post-button span {
  color: white;
  font-size: 1.5rem;
  font-weight: bold;
  letter-spacing: 0.1em;
  pointer-events: none; /* 避免文字影响点击 */
}

.post-button:hover {
  background-color: transparent;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.4);
}

/* 按下的状态，立体感变成按压感，阴影收缩 + 内阴影 */
.post-button:active {
  background-color: transparent;
  transform: translateY(2px); /* 轻微下沉的感觉 */
  box-shadow: inset 0 2px 6px rgba(0, 0, 0, 0.5),
    inset 0 1px 2px rgba(0, 0, 0, 0.4);
}

@media (min-width: 768px) {
  .heading-primary,
  .heading-secondary {
    font-size: 1.875rem;
  }
}
</style>
