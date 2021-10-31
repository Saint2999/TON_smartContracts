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
