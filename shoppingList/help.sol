pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "../base/Debot.sol";
import "../base/Terminal.sol";
import "../base/Menu.sol";
import "../base/AddressInput.sol";
import "../base/ConfirmInput.sol";
import "../base/Sdk.sol";

struct Purchase 
{
    uint32 id;
    string name;
    uint8 quantity;
    uint32 time;
    bool isPurchased;
    uint32 fullPrice;
}

struct summaryOfPurchases
{
    uint8 quantityOfPaidPurchases;
    uint8 quantityOfUnpaidPurchases;
    uint32 amountOfMoneySpent;
}

interface shoppingListInterface 
{
    function getPurchases() external view returns (Purchase[] purchases);
    function addPurchase(string name, uint8 quantity) external;
    function deletePurchase(uint32 id) external;
    function updatePurchase(uint32 id, uint32 price) external;
    function getSummary() external view returns (summaryOfPurchases summary);
}

interface sendTransactionInterface 
{
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}

abstract contract HasConstructorWithPubKey 
{
   constructor(uint256 pubkey) public {}
}