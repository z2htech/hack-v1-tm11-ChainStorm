// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./AuthorManager.sol";
import "./KLT.sol";

contract ContentManager {
    // 定义文章结构体，新增加一个 author 字段用于存储作者地址
    struct Article {
        uint256 id; // 文章ID
        string content; // 文章内容（实际应用中，可将文章内容存到 IPFS，此处保存 IPFS 的 Hash）
        bytes32 contentHash; // 文章内容的 keccak256 哈希
        uint256 likes; // 点赞数量
        uint256 reward; // 打赏金额（单位：wei）
        string[] comments; // 评论列表
        bool release; // 发布状态
        address author; // 作者地址
    }

    // 文章总数（文章ID自增）
    uint256 public articleCount;

    // ERC20 代币
    KLT public rewardToken;
    AuthorManager public AuthorManagerContract;

    // 使用文章ID映射每个文章的信息
    mapping(uint256 => Article) public articles;
    // 可选：通过文章哈希映射到文章ID
    mapping(bytes32 => uint256) public hashToId;

    // 事件声明，新增作者地址字段
    event ArticleCreated(
        uint256 indexed id,
        bytes32 contentHash,
        address indexed author
    );
    event CommentAdded(uint256 indexed articleId, string comment);
    event ArticleLiked(uint256 indexed articleId, uint256 totalLikes);
    event ArticleUpdated(
        uint256 indexed id,
        bytes32 newContentHash,
        bool release
    );
    event ArticleRewarded(
        uint256 indexed articleId,
        uint256 totalReward,
        address donor,
        uint256 amount
    );

    // 构造函数，传入 AuthorManager 合约地址
    constructor(address _authorManagerAddress, address _rewardToken) {
        AuthorManagerContract = AuthorManager(_authorManagerAddress);
        rewardToken = KLT(_rewardToken);
    }

    /**
     * 写文章函数
     * @param _content 文章内容（也可以传 IPFS 上存储的内容哈希）
     *
     * 每次调用该函数，会生成一篇文章，计算内容的 keccak256 哈希，并自动分配文章ID，
     * 同时记录作者地址，并调用 AuthorManager 合约记录文章与作者的关联关系。
     */
    function writeArticle(string memory _content) public {
        // 更新文章计数
        articleCount++;
        // 计算内容哈希
        bytes32 contentHash = keccak256(abi.encodePacked(_content));

        // 创建新的文章
        Article storage newArticle = articles[articleCount];
        newArticle.id = articleCount;
        newArticle.content = _content;
        newArticle.contentHash = contentHash;
        newArticle.likes = 0;
        newArticle.reward = 0;
        newArticle.release = false;
        newArticle.author = msg.sender; // 记录作者地址

        // 将文章哈希映射到文章ID
        hashToId[contentHash] = articleCount;

        // 调用 AuthorManager 合约记录文章与作者的关联
        AuthorManagerContract.addArticleForAuthor(articleCount, msg.sender);

        emit ArticleCreated(articleCount, contentHash, msg.sender);
    }

    /**
     * 写评论函数
     * @param _articleId 要评论的文章ID
     * @param _comment 评论内容
     *
     * 只能对已经存在的文章添加评论
     */
    function addComment(uint256 _articleId, string memory _comment) public {
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );
        articles[_articleId].comments.push(_comment);
        emit CommentAdded(_articleId, _comment);
    }

    /**
     * 点赞函数
     * @param _articleId 要点赞的文章ID
     *
     * 点赞数量累加1
     */
    function likeArticle(uint256 _articleId) public {
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );
        articles[_articleId].likes++;
        emit ArticleLiked(_articleId, articles[_articleId].likes);
    }

    /**
     * 打赏函数
     * @param _articleId 要打赏的文章ID
     *
     * 此函数为 payable，调用时需携带以 wei 为单位的以太币。
     */
    function rewardArticle(uint256 _articleId, uint256 amount) public {
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );
        require(amount > 0, "Reward must be greater than 0");
        // 从打赏者转移代币到当前合约
        require(
            rewardToken.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );
        articles[_articleId].reward += amount;
        emit ArticleRewarded(
            _articleId,
            articles[_articleId].reward,
            msg.sender,
            amount
        );
    }

    // /**
    //  * @dev 更新文章的 contentHash 和 release 状态
    //  * @param _articleId 要更新的文章ID
    //  * @param _newContentHash IPFS 上存储后的文章 hash（必须是 bytes32 类型，如果 IPFS hash 为 string，需转换）
    //  *
    //  * 调用此函数后，将指定文章的 contentHash 更新为传入的新值，同时将 release 状态置为 true，
    //  * 表明该文章已授权并成功存储到 IPFS 上。
    //  */
    function updataArticleRelease(uint256 _articleId) public {
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );
        Article storage article = articles[_articleId];
        article.release = true;
    }

    function updateArticleIPFS(
        uint256 _articleId,
        bytes32 _newContentHash
    ) public {
        // 检查指定的文章是否存在
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );

        Article storage article = articles[_articleId];
        article.contentHash = _newContentHash;
        article.release = true;

        emit ArticleUpdated(_articleId, _newContentHash, true);
    }

    /**
     * @dev 获取所有文章ID
     * @return ids 所有文章ID数组
     */
    function getAllArticleId() public view returns (uint256[] memory) {
        uint256 count = articleCount;
        uint256[] memory ids = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            ids[i] = articles[i + 1].id;
        }
        return ids;
    }

    /**
     * @dev 获取指定文章的评论列表
     * @param _articleId 要查询的文章ID
     * @return 评论字符串数组
     */
    function getArticleComments(
        uint256 _articleId
    ) public view returns (string[] memory) {
        require(
            _articleId > 0 && _articleId <= articleCount,
            "Article does not exist"
        );
        return articles[_articleId].comments;
    }

    /**
     * @dev 获取所有 release 为 true 的文章的 contentHash 数组
     * @return releasedContentHashes 存储满足条件的 contentHash 数组
     */
    function getReleasedArticlesContentHashes()
        public
        view
        returns (bytes32[] memory releasedContentHashes)
    {
        // 先统计满足条件的文章数量
        uint256 count = 0;
        for (uint256 i = 1; i <= articleCount; i++) {
            if (articles[i].release) {
                count++;
            }
        }

        // 分配数组空间
        bytes32[] memory result = new bytes32[](count);

        // 将满足条件的文章 contentHash 添加到结果数组中
        uint256 index = 0;
        for (uint256 i = 1; i <= articleCount; i++) {
            if (articles[i].release) {
                result[index] = articles[i].contentHash;
                index++;
            }
        }

        return result;
    }

    function checkArticleStatus(
        uint256 _articleId
    ) public view returns (bool exists, bool isReleased) {
        // 检查ID有效性[1](@ref)
        exists = (_articleId > 0 && _articleId <= articleCount);

        if (exists) {
            // 获取已发布状态[1](@ref)
            isReleased = articles[_articleId].release;
        } else {
            isReleased = false;
        }
    }
}
