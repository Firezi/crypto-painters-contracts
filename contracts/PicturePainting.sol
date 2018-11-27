pragma solidity ^0.4.0;

import "./PictureBounty.sol";
import "./FrameGenerationInterface.sol";
import "./FrameSellInterface.sol";

contract PicturePainting is PictureBounty {
    uint256 canvasCost;

    FrameGenerationInterface public frameGenerator;
    FrameSellInterface public frameSell;

    function setFrameGeneratorAddress(address _address) external onlyCTO {
        FrameGenerationInterface candidateContract = FrameGenerationInterface(_address);

        require(candidateContract.isFrameGenerationInterface());

        frameGenerator = candidateContract;
    }

    function setFrameSellAddress(address _address) external onlyCTO {
        FrameSellInterface candidateContract = FrameSellInterface(_address);

        require(candidateContract.isFrameSellInterface());

        frameSell = candidateContract;
    }

    function createPictureWithRandomFrame(
        string _name,
        uint256 _pictureHash
    )
        external
        whenNotPaused
        payable
        returns (uint256)
    {
        require(msg.value >= canvasCost || bountyCanvasAmount[msg.sender] > 0);

        uint256 balance = msg.value;
        if (bountyCanvasAmount[msg.sender] > 0) {
            bountyCanvasAmount[msg.sender]--;
        } else {
            balance -= canvasCost;
        }

        uint256 frameSeed = frameGenerator.genFrame(msg.sender, _pictureHash);

        uint256 pictureId = _createPicture(msg.sender, _name, _pictureHash, frameSeed);

        if (balance > 0) {
            msg.sender.transfer(balance);
        }

        return pictureId;
    }

    function createPictureWithPaidFrame(
        string _name,
        uint256 _pictureHash,
        uint256 _frameId
    )
        external
        whenNotPaused
        payable
        returns (uint256)
    {
        require(msg.value >= canvasCost || bountyCanvasAmount[msg.sender] > 0);

        uint256 balance = msg.value;
        if (bountyCanvasAmount[msg.sender] > 0) {
            bountyCanvasAmount[msg.sender]--;
        } else {
            balance -= canvasCost;
        }

        bool framePaid;
        uint256 frameSeed;
        (framePaid, frameSeed, balance) = frameSell.getFrame(_frameId, balance);

        require(framePaid);

        uint256 pictureId = _createPicture(msg.sender, _name, _pictureHash, frameSeed);

        if (balance > 0) {
            msg.sender.transfer(balance);
        }

        return pictureId;
    }

    function createPictureWithBountyFrame(
        string _name,
        uint256 _pictureHash,
        uint256 _frameId
    )
    external
    whenNotPaused
    payable
    returns (uint256)
    {
        require(msg.value >= canvasCost || bountyCanvasAmount[msg.sender] > 0);
        require(_frameId < bountyFrames.length);

        uint256 balance = msg.value;
        if (bountyCanvasAmount[msg.sender] > 0) {
            bountyCanvasAmount[msg.sender]--;
        } else {
            balance -= canvasCost;
        }

        require(bountyFrames[_frameId].recipient == msg.sender);
        bountyFrames[_frameId].isUsed = true;

        uint256 frameSeed = bountyFrames[_frameId].frameSeed;

        uint256 pictureId = _createPicture(msg.sender, _name, _pictureHash, frameSeed);

        if (balance > 0) {
            msg.sender.transfer(balance);
        }

        return pictureId;
    }
}
