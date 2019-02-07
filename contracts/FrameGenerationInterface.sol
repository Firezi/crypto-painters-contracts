pragma solidity ^0.4.24;

contract FrameGenerationInterface {
    function isFrameGenerationInterface() public pure returns (bool);

    function genFrame(address creator, string hash) public returns (uint256 frameSeed);
}
