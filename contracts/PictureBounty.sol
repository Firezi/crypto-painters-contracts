pragma solidity ^0.4.24;

import "./PictureOwnerShip.sol";

contract PictureBounty is PictureOwnerShip {
    uint32 public constant BOUNTY_CANVAS_LIMIT = 1000000;
    uint32 public constant BOUNTY_FRAME_LIMIT = 5000;

    uint32 public totalBountyCanvasAmount = 0;
    uint32 public totalBountyFrameAmount = 0;

    event BountyCanvasGifted(address to, uint32 amount);
    event BountyFrameGifted(address to, uint256 frameSeed);

    mapping (address => uint32) public bountyCanvasAmount;

    struct BountyFrame {
        uint256 frameSeed;
        uint256 unlockTime;
        address recipient;
        bool isUsed;
    }
    BountyFrame[] public bountyFrames;

    function giveBountyCanvas(address _to, uint32 _amount) external onlyCOO {
        require(_amount + totalBountyCanvasAmount > totalBountyCanvasAmount);
        require(_amount + totalBountyCanvasAmount <= BOUNTY_CANVAS_LIMIT);

        bountyCanvasAmount[_to] += _amount;
        totalBountyCanvasAmount += _amount;

        emit BountyCanvasGifted(_to, _amount);
    }

    function giveBountyFrame(address _to, uint256 _frameSeed, uint256 lockTime) external onlyCOO {
        require (totalBountyFrameAmount < BOUNTY_FRAME_LIMIT);

        BountyFrame memory _bountyFrame = BountyFrame({
            frameSeed: _frameSeed,
            unlockTime: now + lockTime,
            recipient: _to,
            isUsed: false
        });

        bountyFrames.push(_bountyFrame);
        totalBountyFrameAmount++;

        emit BountyFrameGifted(_to, _frameSeed);
    }
}
