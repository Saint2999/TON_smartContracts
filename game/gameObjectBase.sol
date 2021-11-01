pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObject.sol";
import "gameObjectBaseInterface.sol";
import "gameObjectMilitaryUnitInterface.sol";

contract gameObjectBase is gameObject
{
    mapping(uint => gameObjectMilitaryUnitInterface) militaryUnitMap;
    uint private mapLength = 0;
    
    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        health = 20;
        defense = 3;
    }
    
    function addMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external accept()
    {
        militaryUnitMap[mapLength] = militaryUnit;
        mapLength++;
    }

    function removeMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external accept()
    {
        for (uint i = 0; i < mapLength; i++)
        {
            if(militaryUnitMap.exists(i))
            {
                if (militaryUnitMap[i] == militaryUnit) delete militaryUnitMap[i];
            }
        }
    }

    function gameObjectDeath(address attackerAddress) public accept() override
    {
        for (uint i = 0; i < mapLength; i++)
        {
            militaryUnitMap[i].gameObjectDeath(attackerAddress);
        }
        attackerAddress.transfer(0, true, 160);
    }
}

