pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObjectMilitaryUnit.sol";

contract gameObjectWarrior is gameObjectMilitaryUnit
{
    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        health = 8;
        defense = 1;
        attack = 5;
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