pragma solidity ^0.4.0;

import "./PictureBounty.sol";
import "./FrameGenerationInterface.sol";

contract PicturePainting is PictureBounty {
    uint256 canvasCost;

    FrameGenerationInterface public frameGenerator;

    function setFrameGeneratorAddress(address _address) external onlyCEO {
        FrameGenerationInterface candidateContract = FrameGenerationInterface(_address);

        require(candidateContract.isFrameGenerationInterface());

        frameGenerator = candidateContract;
    }

    function createPicture(
        string _name,
        uint256 _pictureHash,
        uint256 paidFrameId,
        uint256 FrameId,
        bool bountyCanvasUsed
    )
        external
        whenNotPaused
        payable
        returns(uint256)
    {
        
    }
}
