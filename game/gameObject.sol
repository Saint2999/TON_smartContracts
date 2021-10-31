pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObjectInterface.sol";

abstract contract gameObject is gameObjectInterface
{
    int internal health;
    int internal defense;

    constructor() public 
    {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function takeDamage(int attack) external override
    {
        tvm.accept();
        health = health - (attack - defense);
        if (!gameObjectAlive()) gameObjectDeath(msg.sender);
    }

    function gameObjectAlive() private view returns (bool)
    {
        tvm.accept();
        if (health <= 0) return false;
        else return true;
    }

    function gameObjectDeath(address attackerAddress) virtual internal;
}
