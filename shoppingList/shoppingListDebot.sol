pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "initializationDebot.sol";

contract shoppingListDebot is initializationDebot
{
    uint8 private tempQuantity;

    function start() public override
    {
        Terminal.input(tvm.functionId(savePubkey),"Please enter your public key", false);
    }

    function menu() public override  
    {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "Summary of your purchases: {}/{}/{} (Paid purchases/Unpaid purchases/Money spent)",
                    fullSummary.quantityOfPaidPurchases,
                    fullSummary.quantityOfUnpaidPurchases,
                    fullSummary.amountOfMoneySpent
            ),
            sep,
            [
                MenuItem("Add new purchase","",tvm.functionId(addPurchase)),
                MenuItem("Show shopping list","",tvm.functionId(getPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function addPurchase(uint32 index) public 
    {
        index = index;
        Terminal.input(tvm.functionId(addPurchasePlease), "Name of the product:", false);
    }

    function addPurchasePleaseHelp(string stringQuantity) public
    {
        (uint256 quantity,) = stoi(stringQuantity);
        tempQuantity = uint8(quantity);
    }

    function addPurchasePlease(string name) public  
    {
        Terminal.input(tvm.functionId(addPurchasePleaseHelp), "Quantity of the product:", false);
        optional(uint256) pubkey = 0;
        shoppingListInterface(contractAddress).addPurchase
        {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(name, tempQuantity);
    }

    function getPurchases(uint32 index) public view 
    {
        index = index;
        optional(uint256) none;
        shoppingListInterface(contractAddress).getPurchases
        {
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(getPurchasesPlease),
            onErrorId: 0
        }();
    }
    function getPurchasesPlease(Purchase[] purchases) public 
    {
        uint32 i;
        if (purchases.length > 0 ) 
        {
            Terminal.print(0, "Your shopping list:");
            for (i = 0; i < purchases.length; i++) 
            {
                Purchase purchase = purchases[i];
                string isPurchased;
                if (purchase.isPurchased) 
                {
                    isPurchased = '✓';
                } 
                    else 
                    {
                        isPurchased = ' ';
                    }
                Terminal.print(0, format("{} {}  \"{}\" ({}) at {} for {}", purchase.id, isPurchased, purchase.name, purchase.quantity, purchase.time, purchase.fullPrice));
            }
        } 
            else 
            {
                Terminal.print(0, "Your shopping list is empty");
            }
        menu();
    }

    function deletePurchase(uint32 index) public 
    {
        index = index;
        if (fullSummary.quantityOfPaidPurchases + fullSummary.quantityOfUnpaidPurchases > 0) 
        {
            Terminal.input(tvm.functionId(deletePurchasePlease), "Enter purchase number:", false);
        } 
            else 
            {
                Terminal.print(0, "Sorry, you have no purchases to delete");
                menu();
            }
    }

    function deletePurchasePlease(string value) public view 
    {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        shoppingListInterface(contractAddress).deletePurchase
        {
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(uint32(num));
    }
}
