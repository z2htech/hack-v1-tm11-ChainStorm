import Web3 from "web3";
import ContentManagerJSON from "../json/ContentManager.json";
import bs58 from "bs58";
import { Buffer } from "buffer";

const useContentManager = () => {
  // 初始化 Web3（增强版）
  const getProvider = () => {
    if (typeof window !== "undefined" && window.ethereum) {
      return window.ethereum;
    }
    // 验证 Infura 项目 ID
    const projectId = "b5ec59d9451e4bdeaf5b81d6e87277ee";
    if (!projectId) throw new Error("Missing Infura project ID");
    return `wss://sepolia.infura.io/ws/v3/${projectId}`;
  };

  let web3;
  let ContentManagerContract;
  const contractAddress = "0xe8aA41202DE837e0b9CB448349c662193a32d7d9";

  try {
    web3 = new Web3(getProvider());
    console.log("Web3 instance:", web3);

    // 验证合约地址
    if (!web3.utils.isAddress(contractAddress)) {
      throw new Error("Invalid contract address");
    }

    // 实例化合约
    ContentManagerContract = new web3.eth.Contract(
      ContentManagerJSON.abi,
      contractAddress
    );
    console.log("ContentManager contract instance:", ContentManagerContract);

    // 获取账户（增强错误处理）
    const getAccount = async () => {
      try {
        const accounts = await web3.eth.requestAccounts();
        if (accounts.length === 0) throw new Error("No accounts available");
        return accounts[0];
      } catch (error) {
        console.error("Account error:", error.message);
        return null;
      }
    };

    // 核心交互方法

    // 1. 写文章
    const writeArticle = async (content) => {
      try {
        const account = await getAccount();
        return ContentManagerContract.methods
          .writeArticle(content)
          .send({ from: account });
      } catch (error) {
        console.error("文章发布失败:", error);
        throw new Error(
          error.message.includes("revert") ? "内容不符合要求" : "网络请求失败"
        );
      }
    };

    // 2. 添加评论
    const addComment = async (articleId, comment) => {
      try {
        const account = await getAccount();
        return ContentManagerContract.methods
          .addComment(articleId, comment)
          .send({ from: account });
      } catch (error) {
        console.error("评论失败:", error);
        throw new Error(
          error.message.includes("exist") ? "文章不存在" : "评论内容过长"
        );
      }
    };

    // 3. 点赞文章
    const likeArticle = async (articleId) => {
      try {
        const account = await getAccount();
        return ContentManagerContract.methods
          .likeArticle(articleId)
          .send({ from: account });
      } catch (error) {
        console.error("点赞失败:", error);
        throw new Error("操作过于频繁或文章已删除");
      }
    };

    // 4. 打赏文章
    const rewardArticle = async (articleId, amount) => {
      try {
        const account = await getAccount();
        // 转换打赏金额为 wei
        const weiAmount = web3.utils.toWei(amount.toString(), "ether");
        return ContentManagerContract.methods
          .rewardArticle(articleId, weiAmount)
          .send({ from: account });
      } catch (error) {
        console.error("打赏失败:", error);
        throw new Error(
          error.message.includes("transfer") ? "代币余额不足" : "文章不可打赏"
        );
      }
    };

    // 5. 更新文章发布状态（注意合约中函数名称为 updataArticleRelease）
    const updataArticleRelease = async (articleId) => {
      try {
        const account = await getAccount();
        return ContentManagerContract.methods
          .updataArticleRelease(articleId)
          .send({ from: account });
      } catch (error) {
        console.error("状态更新失败:", error);
        throw new Error("未达到发布要求或权限不足");
      }
    };

    // 6. 更新文章的 IPFS 哈希并发布
    const updateArticleIPFS = async (articleId, ipfsHash) => {
      try {
        const account = await getAccount();
        console.log("传入的 ipfsHash:", ipfsHash);
        // 解码 IPFS CID（例如 "Qm..." 开头）
        const decoded = bs58.decode(ipfsHash);
        console.log("decoded length:", decoded.length);
        // 检查解码长度是否满足 34 字节要求（CID v0）
        if (decoded.length !== 34) {
          throw new Error(
            `CID 解码后的字节数不等于34，目前为 ${decoded.length}`
          );
        }
        // 对于 CID v0，通常前2字节为多哈希前缀，后32字节为实际的哈希值
        const digest = decoded.slice(2, 34);
        const bytes32Hash = "0x" + Buffer.from(digest).toString("hex");
        console.log("转换后的 bytes32Hash:", bytes32Hash);
        // 调用合约方法
        return ContentManagerContract.methods
          .updateArticleIPFS(articleId, bytes32Hash)
          .send({ from: account });
      } catch (error) {
        console.error("IPFS更新失败:", error);
        throw new Error("哈希格式错误或文章不存在");
      }
    };

    // 7. 获取所有文章ID
    const getAllArticleId = async () => {
      try {
        return ContentManagerContract.methods.getAllArticleId().call();
      } catch (error) {
        console.error("文章列表获取失败:", error);
        throw new Error("网络连接异常");
      }
    };

    // 8. 获取指定文章的评论
    const getArticleComments = async (articleId) => {
      try {
        return ContentManagerContract.methods
          .getArticleComments(articleId)
          .call();
      } catch (error) {
        console.error("评论加载失败:", error);
        throw new Error("文章已删除或不存在");
      }
    };

    // 9. 获取所有已发布文章的 contentHash 数组
    const getReleasedArticlesContentHashes = async () => {
      try {
        return ContentManagerContract.methods
          .getReleasedArticlesContentHashes()
          .call();
      } catch (error) {
        console.error("已发布文章加载失败:", error);
        throw new Error("数据解析失败");
      }
    };

    // 10. 检查文章状态（返回是否存在以及是否发布）
    const checkArticleStatus = async (articleId) => {
      try {
        return ContentManagerContract.methods
          .checkArticleStatus(articleId)
          .call();
      } catch (error) {
        console.error("状态查询失败:", error);
        throw new Error("无效的文章ID");
      }
    };

    // 11. 获取所有已发布（release 为 true）的文章ID
    const getReleasedArticleIds = async () => {
      try {
        return ContentManagerContract.methods.getReleasedArticleIds().call();
      } catch (error) {
        console.error("获取已发布文章ID失败:", error);
        throw new Error("获取已发布文章ID失败");
      }
    };

    // 12. 获取所有未发布（release 为 false）的文章ID
    const getUnreleasedArticleIds = async () => {
      try {
        return ContentManagerContract.methods.getUnreleasedArticleIds().call();
      } catch (error) {
        console.error("获取未发布文章ID失败:", error);
        throw new Error("获取未发布文章ID失败");
      }
    };

    // 13. 获取指定文章的详细信息
    const getArticleDetails = async (articleId) => {
      try {
        return ContentManagerContract.methods
          .getArticleDetails(articleId)
          .call();
      } catch (error) {
        console.error("获取文章详情失败:", error);
        throw new Error("无法获取文章详情");
      }
    };

    // 14. 根据内容 hash 查询文章ID（利用 hashToId 映射）
    const getArticleIdByContentHash = async (contentHash) => {
      try {
        return ContentManagerContract.methods.hashToId(contentHash).call();
      } catch (error) {
        console.error("根据内容 hash 获取文章ID失败:", error);
        throw new Error("无法根据内容 hash 获取文章ID");
      }
    };

    // ****** 新增函数：获取合约中 articleCount 数值 ******
    const getArticleCount = async () => {
      try {
        return ContentManagerContract.methods.articleCount().call();
      } catch (error) {
        console.error("获取文章数量失败:", error);
        throw new Error("无法获取文章数量");
      }
    };

    return {
      web3,
      ContentManagerContract,
      contractAddress,
      getAccount,
      // 核心交互方法
      writeArticle,
      addComment,
      likeArticle,
      rewardArticle,
      updataArticleRelease,
      updateArticleIPFS,
      // 查询方法
      getAllArticleId,
      getArticleComments,
      getReleasedArticlesContentHashes,
      checkArticleStatus,
      getReleasedArticleIds,
      getUnreleasedArticleIds,
      getArticleDetails,
      getArticleIdByContentHash,
      // 新增查询合约中文章总数的方法
      getArticleCount,
    };
  } catch (error) {
    console.error("Web3 initialization failed:", error);
    return null;
  }
};

export default useContentManager;
