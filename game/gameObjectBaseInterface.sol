pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "gameObjectMilitaryUnitInterface.sol";

interface gameObjectBaseInterface
{
    function addMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external;
    function removeMilitaryUnit(gameObjectMilitaryUnitInterface militaryUnit) external;
}