pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObject.sol";
import "gameObjectMilitaryUnitInterface.sol";
import "gameObjectBaseInterface.sol";

contract gameObjectMilitaryUnit is gameObject
{
    int internal attack;
    address internal owner;
    gameObjectBaseInterface internal baseAddress;
    gameObjectMilitaryUnitInterface internal militaryUnitAddress;

    function getAttack() public view returns (int)
    {
        tvm.accept();
        return attack;
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

    function attackGameObject(gameObjectInterface tempGameObjectAddress) public
    {
        tvm.accept();
        tempGameObjectAddress.takeDamage(attack);
    }

    function gameObjectDeath(address attackerAddress) virtual internal override
    {
        tvm.accept();
        require(baseAddress == msg.sender, 999);
        baseAddress.removeMilitaryUnit(militaryUnitAddress);
        attackerAddress.transfer(0, true, 160);
    }
}
