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
        owner = msg.sender;
    }

    function connectToBase(gameObjectMilitaryUnitInterface tempMilitaryUnitAddress, gameObjectBaseInterface tempBaseAddress) public
    {
        tvm.accept();
        require(owner == msg.sender, 999);
        baseAddress = tempBaseAddress;
        militaryUnitAddress = tempMilitaryUnitAddress;
        baseAddress.addMilitaryUnit(militaryUnitAddress);
    }
}