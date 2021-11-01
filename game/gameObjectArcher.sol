pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObjectMilitaryUnit.sol";

contract gameObjectArcher is gameObjectMilitaryUnit
{
    constructor() public 
    {
        require(tvm.pubkey() != 0, 103);
        require(msg.pubkey() == tvm.pubkey(), 104);
        tvm.accept();
        health = 5;
        defense = 0;
        attack = 7;
    }

    function connectToBase(gameObjectMilitaryUnitInterface tempMilitaryUnitAddress, gameObjectBaseInterface tempBaseAddress) public accept()
    {
        baseAddress = tempBaseAddress;
        militaryUnitAddress = tempMilitaryUnitAddress;
        baseAddress.addMilitaryUnit(militaryUnitAddress);
    }
    
    function gameObjectDeath(address attackerAddress) public accept() override
    {
        baseAddress.removeMilitaryUnit(militaryUnitAddress);
        attackerAddress.transfer(0, true, 160);
    }
}
