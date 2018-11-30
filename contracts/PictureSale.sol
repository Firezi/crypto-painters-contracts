pragma solidity ^0.4.24;

import "./PicturePainting.sol";

contract PictureSale is PicturePainting {
    struct Sale {
        address seller;
        uint256 price;
    }

    uint256 saleCut;

    mapping (uint256 => Sale) public tokenIdToSale;

    event SaleCreated(uint256 tokenId, uint256 price);
    event SaleSuccessful(uint256 tokenId, address buyer);
    event SaleCancelled(uint256 tokenId);

    function _isOnSale(uint256 _tokenId) internal view returns (bool) {
        return (tokenIdToSale[_tokenId].seller != address(0));
    }

    function createSale(uint256 _tokenId, uint256 _price) external whenNotPaused {
        require(_owns(msg.sender, _tokenId));
        require(_price == uint256(uint128(_price)));

        _transfer(msg.sender, address(this), _tokenId);

        tokenIdToSale[_tokenId] = Sale({
            seller: msg.sender,
            price: _price
        });

        emit SaleCreated(_tokenId, _price);
    }

    function buy(uint256 _tokenId) external payable whenNotPaused {
        require(_isOnSale(_tokenId));

        uint256 price = tokenIdToSale[_tokenId].price;
        address seller = tokenIdToSale[_tokenId].seller;

        uint256 fullPrice = price * (saleCut + 10000) / 10000;
        require(msg.value >= fullPrice);

        delete tokenIdToSale[_tokenId];

        if (price > 0) {
            seller.transfer(price);
        }

        uint256 excess = msg.value - fullPrice;
        if (excess > 0) {
            msg.sender.transfer(excess);
        }

        _transfer(address(this), msg.sender, _tokenId);

        emit SaleSuccessful(_tokenId, msg.sender);
    }

    function cancelSale(uint256 _tokenId) external whenNotPaused {
        Sale storage sale = tokenIdToSale[_tokenId];

        require(_isOnSale(_tokenId));
        require(sale.seller == msg.sender);

        delete tokenIdToSale[_tokenId];
        _transfer(address(this), sale.seller, _tokenId);

        emit SaleCancelled(_tokenId);
    }
}
