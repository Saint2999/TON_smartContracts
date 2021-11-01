pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObject.sol";
import "gameObjectMilitaryUnitInterface.sol";
import "gameObjectBaseInterface.sol";

abstract contract gameObjectMilitaryUnit is gameObject
{
    int internal attack;
    gameObjectBaseInterface internal baseAddress;
    gameObjectMilitaryUnitInterface internal militaryUnitAddress;

    function getAttack() public accept() view returns (int)
    {
        return attack;
    }
    
    function attackGameObject(gameObjectInterface tempGameObjectAddress) accept() external
    {
        tempGameObjectAddress.takeDamage(attack);
    }

    function gameObjectDeath(address attackerAddress) virtual public override;
}
