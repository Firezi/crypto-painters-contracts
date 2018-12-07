pragma solidity ^0.4.24;

contract FrameGeneration {
    function isFrameGenerationInterface() public pure returns (bool) {
        return true;
    }

    address public pictureCore;

    bytes32 num = 0xf5a4dc;

    function _genNum() internal {
        bytes32 _num = num;
        bytes32 a = keccak256(num);

        for (uint i = 0; i < 8; i++) {
            uint256 shift = uint256(keccak256(i, now, a)) % 31;
            _num = keccak256(_num ^ (num >> shift));
        }

        num = _num;
    }

    function genFrame(address creator, uint256 hash) public returns (uint256) {
        // require(msg.sender == pictureCore);

        _genNum();

        bytes32 preSeed = keccak256(num, creator, block.number);
        bytes32 seed = keccak256(hash, preSeed, hash);

        seed = seed & 0x000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        seed = seed | 0x0010000000000000000000000000000000000000000000000000000000000000;

        return uint256(seed);
    }
}
