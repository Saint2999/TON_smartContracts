pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract myTokens 
{
    struct token
    {
        string heroName;
        uint8 age;
        bool isAlive;
        bool onSale;
    }

    token[] tokenArray;
    mapping(uint => uint) tokenToOwner;
    mapping(uint => uint) tokenPrice;

    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept(uint tokenId) 
    {
		require(msg.pubkey() == tokenToOwner[tokenId], 666);
        tvm.accept();
		_;
	}

    function createToken(string heroName, uint8 age, bool isAlive) public
    {
        tvm.accept();
        for (token tempToken: tokenArray)
        {
            require(heroName != tempToken.heroName, 999);
        }
        tokenArray.push(token(heroName, age, isAlive, false));
        uint tokenId = tokenArray.length - 1;
        tokenToOwner[tokenId] = msg.pubkey();
        tokenPrice[tokenId] = 0;
    }
    
    function getTokenOwner(uint tokenId) public view returns (uint)
    {
        require(tokenToOwner.exists(tokenId) != false, 299);
        return tokenToOwner[tokenId];
    }

    function getTokenInfo(uint tokenId) public view returns (string heroName, uint8 age, bool isAlive, bool onSale)
    {
        heroName = tokenArray[tokenId].heroName;
        age = tokenArray[tokenId].age;
        isAlive = tokenArray[tokenId].isAlive;
        onSale = tokenArray[tokenId].onSale;
    }

    function getTokenPrice(uint tokenId) public view returns (uint)
    {
        require(tokenArray[tokenId].onSale != false, 199);
        return tokenPrice[tokenId];
    }

    function changeOwner(uint tokenId, uint pubKeyOfNewOwner) public checkOwnerAndAccept(tokenId)
    {
        tokenToOwner[tokenId] = pubKeyOfNewOwner; 
    }

    function changePrice(uint tokenId, uint newPrice) public checkOwnerAndAccept(tokenId)
    {
        tokenArray[tokenId].onSale = true;
        tokenPrice[tokenId] = newPrice; 
    }
}
