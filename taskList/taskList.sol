pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract taskList 
    {
	struct list
    {
        string caseName;
        uint32 timestamp;
        bool done;
    }

    int8 public key = 0;

    mapping(int8 => list) public tasks;

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

	function addToList(string name) public checkOwnerAndAccept 
    {
        require(name.empty() != true, 999);
        key++;
        tasks[key] = list(name, now, false);
	}

    function allTasksNum() public checkOwnerAndAccept view returns (int8)
    {
        require(tasks.empty() != true, 222);
        int8 k = 0;
        for (int8 i = 1; i <= key; i++) if (tasks.exists(i)) k++;
        return k;
    }
    
    function oneTask(int8 tempKey) public checkOwnerAndAccept view returns (list)
    {
        require(tasks.exists(tempKey) != false, 666);
        return tasks[tempKey];
    }

    function delOneTask(int8 tempKey) public checkOwnerAndAccept 
    {
        require(tasks.exists(tempKey) != false, 666);
        delete tasks[tempKey];
    }

    function flagOneTask(int8 tempKey) public checkOwnerAndAccept 
    {
        require(tasks.exists(tempKey) != false, 666);
        tasks[tempKey].done = true;
    }
}