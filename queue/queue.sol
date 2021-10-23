pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract queue 
    {

	string[] public storeQueue;

	constructor() public 
    {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept 
    {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	function getInLine(string name) public checkOwnerAndAccept 
    {
        require(name.empty() != true, 999);
        storeQueue.push(name);
	}

    function nextInLine() public checkOwnerAndAccept 
    {
        require(storeQueue.empty() != true, 666);
        if (storeQueue.length == 1) storeQueue.pop();
        else
        {
            delete storeQueue[0];
            for (uint i = 0; i < (storeQueue.length - 1); i++) storeQueue[i] = storeQueue[i+1];
            storeQueue.pop();
        }
	}
}