pragma solidity ^0.4.24;

contract FrameGenerationInterface {
    function isFrameGenerationInterface() public pure returns (bool);

    function genFrame(address creator, uint256 hash, uint256 selectedFrame, uint256 selectedFrameType)
    public returns (bool framePaid, uint256 frameSeed, uint256 balance);
}
