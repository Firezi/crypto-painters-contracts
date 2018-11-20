pragma solidity ^0.4.24;

import "./PictureBase.sol";
import "./ERC721.sol";

contract PictureOwnerShip is PictureBase, ERC721 {
    string public constant name = "CryptoPainters";
    string public constant symbol = "CP";

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return pictureIndexToOwner[_tokenId] == _claimant;
    }

    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return pictureIndexToApproved[_tokenId] == _claimant;
    }

    function _approve(uint256 _tokenId, address _approved) internal {
        pictureIndexToApproved[_tokenId] = _approved;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return ownershipTokenCount[_owner];
    }

    function transfer(address _to, uint256 _tokenId) external whenNotPaused {
        require(_to != address(0));
        require(_to != address(this));

        require(_owns(msg.sender, _tokenId));

        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) external whenNotPaused {
        require(_owns(msg.sender, _tokenId));

        _approve(_tokenId, _to);

        emit Approval(msg.sender, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused {
        require(_to != address(0));
        require(_to != address(this));

        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));

        _transfer(_from, _to, _tokenId);
    }

    function totalSupply() public view returns (uint) {
        return pictures.length;
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return pictureIndexToOwner[_tokenId];
    }

    function tokensOfOwner(address _owner) external view returns (uint256[]) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            return new uint256[](0);
        }

        uint256[] memory result = new uint256[](tokenCount);
        uint256 totalPictures = totalSupply();
        uint256 resultIndex = 0;

        uint256 i;
        for (i = 1; i < totalPictures; i++) {
            if (pictureIndexToOwner[i] == _owner) {
                result[resultIndex] = i;
                resultIndex++;
            }
        }

        return result;
    }
}
