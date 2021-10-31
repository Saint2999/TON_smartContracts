pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface gameObjectMilitaryUnitInterface
{
    function gameObjectDeath(address attackerAddress) external;
}