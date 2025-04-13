<template>
  <nav class="navbar">
    <div class="logo-container">
      <img src="../assets/image/loge.png" alt="DSDN Logo" class="logo-image" />
      <img
        src="../assets/image/DSRN_mini.png"
        alt="DSDN Text"
        class="logo-text-image"
      />
    </div>

    <div class="nav-links">
      <router-link
        to="/Home"
        class="nav-link"
        :class="{ active: currentRoute === '/Home' }"
      >
        Home
      </router-link>
      <router-link
        to="/post"
        class="nav-link"
        :class="{ active: currentRoute === '/post' }"
      >
        Post
      </router-link>
      <router-link
        to="/profile"
        class="nav-link"
        :class="{ active: currentRoute === '/profile' }"
      >
        Profile
      </router-link>
      <!-- 使用 a 标签替换 Moderation 的 router-link 并添加点击事件 -->
      <a
        class="nav-link"
        :class="{
          active:
            currentRoute === '/Reviewer' || currentRoute === '/noReviewer',
        }"
        @click="handleModerationClick"
      >
        Moderation
      </a>
    </div>

    <button
      class="connect-button"
      @click="connectWallet"
      :class="{ connected: isWalletConnected }"
    >
      {{ walletButtonText }}
    </button>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import useContentReviewDAO from "../composables/useContentReviewDAO";

const route = useRoute();
const router = useRouter();

// 当前路由路径
const currentRoute = computed(() => route.path);

const isWalletConnected = ref(false);
const walletAddress = ref("");
const walletButtonText = computed(() =>
  isWalletConnected.value ? "Connected" : "Connect Wallet"
);

// 用于判断当前账户是否为审核者
const isReviewer = ref(false);

onMounted(async () => {
  checkWalletConnection();
  const dao = useContentReviewDAO();
  if (!dao) {
    console.error("Web3 初始化失败");
    return;
  }

  try {
    const account = await dao.getAccount();
    if (!account) {
      console.error("未连接钱包");
      return;
    }
    // 调用 isAddressReviewer 函数并将其返回结果赋给 isReviewer.value
    isReviewer.value = await dao.isAddressReviewer(account);
    console.log("isReviewer:", isReviewer.value);
  } catch (error) {
    console.error("获取DAO1信息失败:", error);
  }
});

// 检查钱包是否已连接
const checkWalletConnection = async () => {
  try {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_accounts",
      });
      if (accounts.length > 0) {
        isWalletConnected.value = true;
        walletAddress.value = accounts[0];
        console.log("Wallet already connected:", walletAddress.value);
        setupAccountListeners();
      }
    }
  } catch (error) {
    console.error("Error checking wallet connection:", error);
  }
};

// 连接钱包
const connectWallet = async () => {
  if (isWalletConnected.value) {
    console.log("Wallet already connected:", walletAddress.value);
    return;
  }
  try {
    if (window.ethereum) {
      console.log("Connecting wallet...");
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      if (accounts.length > 0) {
        isWalletConnected.value = true;
        walletAddress.value = accounts[0];
        console.log("Wallet connected:", walletAddress.value);
        setupAccountListeners();
      }
    } else {
      alert("Please install MetaMask or another Ethereum wallet to connect");
    }
  } catch (error) {
    console.error("Error connecting wallet:", error);
    alert("Error connecting wallet. Please try again.");
  }
};

// 账户更改监听
const setupAccountListeners = () => {
  if (window.ethereum) {
    window.ethereum.on("accountsChanged", (accounts) => {
      if (accounts.length === 0) {
        isWalletConnected.value = false;
        walletAddress.value = "";
        console.log("Wallet disconnected");
      } else {
        walletAddress.value = accounts[0];
        console.log("Wallet account changed:", walletAddress.value);
      }
    });
  }
};

// Moderation 点击处理函数，判断是否为审核者
const handleModerationClick = () => {
  if (isReviewer.value) {
    router.push("/Reviewer");
  } else {
    router.push("/noReviewer");
  }
};
</script>

<style scoped>
@font-face {
  font-family: "SFProDisplayBold";
  src: url("/src/assets/font/SFPRODISPLAYBOLD.OTF") format("opentype");
  font-weight: bold;
  font-style: normal;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.4rem 2rem;
  background-color: #0a0118;
  border-bottom: 2px solid;
  border-image: linear-gradient(
      90deg,
      #401f4b,
      #9848b1,
      #f1c8fd,
      #9848b1,
      #401f4b
    )
    1;
}

.logo-container {
  display: flex;
  align-items: center;
}

.logo-image {
  width: 60px;
  height: 60px;
  margin-right: 0.5rem;
}

.logo-text-image {
  height: 30px;
  margin-top: 7px;
}

.nav-links {
  display: flex;
  gap: 10rem;
}

.nav-link {
  color: white;
  font-family: "SFProDisplayBold", sans-serif;
  text-decoration: none;
  font-size: 1.5rem;
  padding: 0.5rem 0;
  margin-top: 8px;
  transition: border-bottom 0.2s ease;
  cursor: pointer;
}

.nav-link.active {
  border-bottom: 1px solid;
  border-image: linear-gradient(90deg, #472c67, #d1ace3, #472c67) 1;
}

.connect-button {
  background-color: #8502d1;
  font-family: "SFProDisplayBold", sans-serif;
  color: white;
  border: none;
  border-radius: 20px;
  padding: 0.5rem 1.5rem;
  font-size: 1.5rem;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.connect-button:hover {
  background-color: #9b00e8;
}

.connect-button.connected {
  color: #a601da;
  background-color: #400065;
}
</style>
