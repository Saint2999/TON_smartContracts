pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "help.sol";

contract shoppingList 
{
    uint256 ownerPubkey;
    uint32 mapCount;
    mapping(uint32 => Purchase) mapOfPurchases;
    
    constructor(uint256 pubkey) public 
    {
        require(pubkey != 0, 120);
        tvm.accept();
        ownerPubkey = pubkey;
    }

    modifier onlyOwner() 
    {
        require(msg.pubkey() == ownerPubkey, 101);
        _;
    }

    function getPurchases() public view returns (Purchase[] purchases) 
    {
        string name;
        uint8 quantity;
        uint32 time;
        bool isPurchased;
        uint32 fullPrice;
        for((uint32 id, Purchase purchase) : mapOfPurchases) 
        {
            name = purchase.name;
            quantity = purchase.quantity;
            time = purchase.time;
            isPurchased = purchase.isPurchased;
            fullPrice = purchase.fullPrice;
            purchases.push(Purchase(id, name, quantity, time, isPurchased, fullPrice));
       }
    }

    function addPurchase(string name, uint8 quantity) public onlyOwner 
    {
        tvm.accept();
        mapCount++;
        mapOfPurchases[mapCount] = Purchase(mapCount, name, quantity, now, false, 0);
    }

    function deletePurchase(uint32 id) public onlyOwner 
    {
        require(mapOfPurchases.exists(id), 102);
        tvm.accept();
        delete mapOfPurchases[id];
    }

    function updatePurchase(uint32 id, uint32 price) public onlyOwner 
    {
        optional(Purchase) purchase = mapOfPurchases.fetch(id);
        require(purchase.hasValue(), 102);
        tvm.accept();
        Purchase thisPurchase = purchase.get();
        thisPurchase.isPurchased = true;
        thisPurchase.fullPrice = (price*thisPurchase.quantity);
        mapOfPurchases[id] = thisPurchase;
    }

    function getSummary() public view returns (summaryOfPurchases summary) 
    {
        uint8 quantityOfPaidPurchases;
        uint8 quantityOfUnpaidPurchases;
        uint32 amountOfMoneySpent;

        for((, Purchase purchase) : mapOfPurchases) 
        {
            if  (purchase.isPurchased) 
            {
                quantityOfPaidPurchases++;
                amountOfMoneySpent += purchase.fullPrice;
            } 
                else 
                {
                    quantityOfUnpaidPurchases++;
                }
        }
        summary = summaryOfPurchases( quantityOfPaidPurchases, quantityOfUnpaidPurchases, amountOfMoneySpent);
    }
}
