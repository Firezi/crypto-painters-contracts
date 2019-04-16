pragma solidity ^0.4.24;

import "./PictureSale.sol";

contract PictureCore is PictureSale {
    constructor() public {
        paused = true;
        ceoAddress = msg.sender;
    }

    address public lastPingFrom;
    uint256 public pingCost = 0;

    function setPingCost(uint256 _cost) external onlyCOO {
        pingCost = _cost;
    }

    function setCanvasCost(uint256 _cost) external onlyCOO {
        canvasCost = _cost;
    }
gg
    function setSaleCut(uint256 _cut) external onlyCOO {
        require(_cut <= 10000);
        saleCut = _cut;
    }

    function withdrawBalance() external onlyCOO {
        uint256 balance = address(this).balance;

        if (balance > 0) {
            cooAddress.transfer(balance);
        }
    }

    function ping() external payable {
        require(msg.value >= pingCost);
        lastPingFrom = msg.sender;
    }

    function getPicture(uint256 _id)
    external
    view
    returns (
        address creator,
        string name,
        uint256 creationTime,
        string hash,
        bytes32 frameSeed,
        address owner,
        bool onSale
    ) {
        Picture storage picture = pictures[_id];

        creator = picture.creator;
        name = picture.name;
        creationTime = picture.creationTime;
        hash = picture.hash;
        frameSeed = bytes32(picture.frameSeed);
        owner = pictureIndexToOwner[_id];
        onSale = _isOnSale(_id);
    }
}
