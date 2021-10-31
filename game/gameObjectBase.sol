pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObject.sol";
import "gameObjectBaseInterface.sol";
import "gameObjectMilitaryUnitInterface.sol";

contract gameObjectBase is gameObject
{
    //gameObjectMilitaryUnitInterface[] private militaryUnitArray;
    mapping(uint => gameObjectMilitaryUnitInterface) militaryUnitMap;
    address internal owner;
    uint public mapLength = 0;
    
    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        health = 20;
        defense = 3;
        owner = msg.sender;
    }
    
    function getUnit() public view returns (gameObjectMilitaryUnitInterface)
    {
        tvm.accept();
        return militaryUnitMap[0];
    }

    function getHealth() public view returns (int)
    {
        tvm.accept();
        return health;
    }
    
    function getDefense() public view returns (int)
    {
        tvm.accept();
        return defense;
    }

    function addMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external
    {
        tvm.accept();
        //require(owner == msg.sender, 999);
        militaryUnitMap[mapLength] = militaryUnit;
        mapLength++;
    }

    function removeMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external
    {
        tvm.accept();
        //require(owner == msg.sender, 999);
        //require(militaryUnitArray.empty() != true, 666);
        for (uint i = 0; i < mapLength; i++)
        {
            if (militaryUnitMap[i] == militaryUnit)
            {
                delete militaryUnitMap[i];
            }
        }
    }

    function gameObjectDeath(address attackerAddress) internal override
    {
        tvm.accept();
        for (uint i = 0; i < mapLength; i++)
        {
            militaryUnitMap[i].gameObjectDeath(attackerAddress);
        }
        attackerAddress.transfer(0, true, 160);
    }
}

