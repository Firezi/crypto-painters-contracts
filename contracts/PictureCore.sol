pragma solidity ^0.4.24;

import "./PictureSale.sol";

contract PictureCore is PictureSale {
    constructor() public {
        paused = true;
        ceoAddress = msg.sender;
    }

    function setCanvasCost(uint256 _cost) external onlyCOO {
        canvasCost = _cost;
    }

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
}
