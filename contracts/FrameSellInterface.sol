pragma solidity ^0.4.24;

contract FrameSellInterface {
    function isFrameSellInterface() public pure returns (bool);

    function getFrame(uint256 frameId, uint256 paidAmount)
    external returns (bool framePaid, uint256 frameSeed, uint256 balance);
}
