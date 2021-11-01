pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObjectInterface.sol";

abstract contract gameObject is gameObjectInterface
{
    int internal health;
    int internal defense;

    modifier accept()
    {
        tvm.accept();
        _;
    }
    
    function getHealth() public accept() view returns (int)
    {
        return health;
    }
    
    function getDefense() public accept() view returns (int)
    {
        return defense;
    }

    function takeDamage(int attack) external accept() override
    {
        health = health - (attack - defense);
        if (!gameObjectAlive()) gameObjectDeath(msg.sender);
    }

    function gameObjectAlive() private accept() view returns (bool)
    {
        if (health <= 0) return false;
        else return true;
    }

    function gameObjectDeath(address attackerAddress) virtual public;
}
