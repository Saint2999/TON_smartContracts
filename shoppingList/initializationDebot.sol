pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "help.sol";

abstract contract initializationDebot is Debot
{
    bytes m_icon;
    TvmCell ShoppingListCode;
    TvmCell ShoppingListData;
    TvmCell ShoppingListStateInit;
    uint256 ownerPubkey;
    address contractAddress; 
    address walletAddress;
    summaryOfPurchases fullSummary;
    uint32 INITIAL_BALANCE = 299999999;

    function setShoppingListCode(TvmCell code, TvmCell data) public 
    {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        ShoppingListCode = code;
        ShoppingListData = data;
        ShoppingListStateInit = tvm.buildStateInit(ShoppingListCode, ShoppingListData);
    }

    function savePubkey(string value) public 
    {
        (uint res, bool status) = stoi("0x"+value);
        if (status) 
        {
            ownerPubkey = res;
            Terminal.print(0, "Checking if you already have a shopping list ...");
            TvmCell deployState = tvm.insertPubkey(ShoppingListStateInit, ownerPubkey);
            contractAddress = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your shoppingList contract address is {}", contractAddress));
            Sdk.getAccountType(tvm.functionId(checkStatus), contractAddress);
        } 
            else 
            {
                Terminal.input(tvm.functionId(savePubkey),"Wrong public key. Try again!\nPlease enter your public key", false);
            }
    }


    function checkStatus(int8 acc_type) public 
    {
        if (acc_type == 1) 
        { 
            getSummary(tvm.functionId(setSummary));
        } 
            else if (acc_type == -1)  
            { 
                Terminal.print(0, "You don't have a shopping list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
                AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");
            } 
                else  if (acc_type == 0) 
                { 
                    Terminal.print(0, format("Deploying new contract. If an error occurs, check if your shoppingList contract has enough tokens on its balance"));
                    deploy();
                } 
                    else if (acc_type == 2) 
                    {  
                        Terminal.print(0, format("Can not continue: account {} is frozen", contractAddress));
                    }
    }

    function getSummary(uint32 answerId) private view 
    {
        optional(uint256) none;
        shoppingListInterface(contractAddress).getSummary
        {
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function setSummary(summaryOfPurchases summary) public {
        fullSummary = summary;
        menu();
    }

    function menu() public virtual;

    function creditAccount(address value) public 
    {
        walletAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        sendTransactionInterface(walletAddress).sendTransaction
        {
           abiVer: 2,
           extMsg: true,
           sign: true,
           pubkey: pubkey,
           time: uint64(now),
           expire: 0,
           callbackId: tvm.functionId(waitBeforeDeploy),
          onErrorId: tvm.functionId(onErrorRepeatCredit)  
        }
       (contractAddress, INITIAL_BALANCE, false, 3, empty);
    }

    function waitBeforeDeploy() public  
    {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), contractAddress);
    }

    function checkIfStatusIs0(int8 acc_type) public 
    {
        if (acc_type ==  0) 
        {
            deploy();
        } 
            else 
            {
                waitBeforeDeploy();
            }
    }

    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public 
    {
        sdkError;
        exitCode;
        creditAccount(walletAddress);
    }

    function deploy() private view 
    {
            TvmCell image = tvm.insertPubkey(ShoppingListStateInit, ownerPubkey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: contractAddress,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),    
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {HasConstructorWithPubKey, ownerPubkey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    } 

    function onSuccess() public view 
    {
        getSummary(tvm.functionId(setSummary));
    }

    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view 
    {
        sdkError;
        exitCode;
        deploy();
    }

    function onError(uint32 sdkError, uint32 exitCode) public 
    {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        menu();
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "TODO DeBot";
        version = "0.2.0";
        publisher = "TON Labs";
        key = "TODO list manager";
        author = "TON Labs";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a TODO DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }
}