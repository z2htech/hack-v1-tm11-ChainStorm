// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AuthorManager {
    // 定义作者结构体，新增 articleIds 数组，用于存储该作者所有文章的 id
    struct Author {
        string authorName;
        uint256 authorId;
        uint256[] articleIds;
    }

    // 记录已注册的作者总数（作者ID自增）
    uint256 public authorCount;

    // 存放所有作者信息的数组
    Author[] public authors;

    // 映射：作者ID 到 注册者的地址
    mapping(uint256 => address) public authorAddressMapping;
    // 映射：作者ID 到 作者名称
    mapping(uint256 => string) public authorStringMapping;
    // 映射：判断某个地址是否已经注册，避免重复注册
    mapping(address => bool) public isRegistered;
    // 映射：用户地址 到 作者ID，便于快速查询作者在数组中的索引（注意：作者ID从1开始）
    mapping(address => uint256) public authorIdMapping;

    // 事件：用户注册成功后触发
    event AuthorRegistered(
        uint256 indexed authorId,
        address indexed authorAddress,
        string authorName
    );

    /**
     * @dev 用户注册函数
     * @param _authorName 用户要注册的名称
     *
     * 要求每个地址只能注册一次。
     */
    function registerAuthor(string memory _authorName) public {
        // 检查 msg.sender 是否已注册
        require(!isRegistered[msg.sender], "Address already registered.");

        // 更新计数器，生成新的作者ID
        authorCount++;
        uint256 newAuthorId = authorCount;

        // 将新用户信息存储到数组中，同时初始化文章数组为空
        authors.push(
            Author({
                authorName: _authorName,
                authorId: newAuthorId,
                articleIds: new uint256[](0)
            })
        );

        // 更新映射信息
        authorAddressMapping[newAuthorId] = msg.sender;
        authorStringMapping[newAuthorId] = _authorName;
        isRegistered[msg.sender] = true;
        authorIdMapping[msg.sender] = newAuthorId;

        // 触发用户注册事件
        emit AuthorRegistered(newAuthorId, msg.sender, _authorName);
    }

    /**
     * @dev 给已注册的作者添加一篇文章的id
     * @param _articleId 要添加的文章id
     */
    function addArticleForAuthor(
        uint256 _articleId,
        address _authorAddress
    ) public {
        // 检查该地址是否已注册
        require(isRegistered[_authorAddress], "Address not registered.");

        // 获取注册时映射的作者 ID，并转换为数组的正确索引
        uint256 authorIndex = authorIdMapping[_authorAddress] - 1;

        // 在正确的作者记录中添加文章 id
        authors[authorIndex].articleIds.push(_articleId);
    }

    /**
     * @dev 查询某个用户的所有文章id
     * @param _authorAddress 用户的地址
     * @return 返回该作者的所有文章 id 数组
     */
    function getArticlesForAuthor(
        address _authorAddress
    ) public view returns (uint256[] memory) {
        // 检查传入地址是否已注册
        require(isRegistered[_authorAddress], "Address not registered.");
        uint256 authorId = authorIdMapping[_authorAddress];
        return authors[authorId - 1].articleIds;
    }
}
