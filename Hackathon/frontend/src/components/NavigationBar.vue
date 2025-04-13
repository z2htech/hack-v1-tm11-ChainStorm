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
        >Home</router-link
      >
      <router-link
        to="/post"
        class="nav-link"
        :class="{ active: currentRoute === '/post' }"
        >Post</router-link
      >
      <router-link
        to="/profile"
        class="nav-link"
        :class="{ active: currentRoute === '/profile' }"
        >Profile</router-link
      >
      <router-link
        to="/moderation"
        class="nav-link"
        :class="{ active: currentRoute === '/moderation' }"
        >Moderation</router-link
      >
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
import { useRoute } from "vue-router";

const route = useRoute();
const currentRoute = computed(() => route.path);

const isWalletConnected = ref(false);
const walletAddress = ref("");
const walletButtonText = computed(() =>
  isWalletConnected.value ? "Connected" : "Connect Wallet"
);

// Check if wallet is already connected on component mount
onMounted(() => {
  checkWalletConnection();
});

// Check if wallet is already connected
const checkWalletConnection = async () => {
  try {
    // Check if ethereum object exists (MetaMask or other wallet)
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_accounts",
      });
      if (accounts.length > 0) {
        isWalletConnected.value = true;
        walletAddress.value = accounts[0];
        console.log("Wallet already connected:", walletAddress.value);
        setupAccountListeners(); // Call setupAccountListeners here
      }
    }
  } catch (error) {
    console.error("Error checking wallet connection:", error);
  }
};

// Connect wallet function
const connectWallet = async () => {
  if (isWalletConnected.value) {
    console.log("Wallet already connected:", walletAddress.value);
    return;
  }

  try {
    // Check if ethereum object exists (MetaMask or other wallet)
    if (window.ethereum) {
      console.log("Connecting wallet...");

      // Request account access
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });

      if (accounts.length > 0) {
        isWalletConnected.value = true;
        walletAddress.value = accounts[0];
        console.log("Wallet connected:", walletAddress.value);
        setupAccountListeners(); // Call setupAccountListeners here
      }
    } else {
      alert("Please install MetaMask or another Ethereum wallet to connect");
    }
  } catch (error) {
    console.error("Error connecting wallet:", error);
    alert("Error connecting wallet. Please try again.");
  }
};

// Function to set up account change listeners
const setupAccountListeners = () => {
  if (window.ethereum) {
    window.ethereum.on("accountsChanged", (accounts) => {
      if (accounts.length === 0) {
        // User disconnected wallet
        isWalletConnected.value = false;
        walletAddress.value = "";
        console.log("Wallet disconnected");
      } else {
        // User changed account
        walletAddress.value = accounts[0];
        console.log("Wallet account changed:", walletAddress.value);
      }
    });
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
  line-height: 0.8; /* �����иߣ�������������λ�� */
  margin-top: 8px; /* ��һ��������������λ�� */
  transition: border-bottom 0.2s ease;
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
