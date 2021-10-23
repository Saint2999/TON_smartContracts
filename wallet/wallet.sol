
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract wallet 
{
    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept 
    {
		require(msg.pubkey() == tvm.pubkey(), 666);
		tvm.accept();
		_;
	}

    function sendValueForAdvancedUsers(address dest, uint128 amount, bool bounce, uint16 flag) public pure checkOwnerAndAccept 
    {
        dest.transfer(amount, bounce, flag);
    }

    function sendValueWithoutFee(address dest, uint128 amount) public pure checkOwnerAndAccept 
    {
        dest.transfer(amount, true, 0);
    }

    function sendValueWithFee(address dest, uint128 amount) public pure checkOwnerAndAccept 
    {
        dest.transfer(amount, true, 1);
    }
    function sendValueAndDestroyWallet(address dest) public pure checkOwnerAndAccept 
    {
        dest.transfer(0, true, 160);
    }
}
