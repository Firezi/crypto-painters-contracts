pragma solidity ^0.4.24;

import "./PictureAccessControl.sol";

contract PictureBase is PictureAccessControl {
    event PictureCreation(address creator, uint256 pictureId, uint hash, uint frameSeed);

    event Transfer(address from, address to, uint256 tokenId);

    struct Picture {
        address creator;
        string name;
        uint64 creationTime;
        uint256 hash;
        uint256 frameSeed;
    }

    Picture[] pictures;

    mapping (uint256 => address) public pictureIndexToOwner;

    mapping (address => uint256) ownershipTokenCount;

    mapping (uint256 => address) public pictureIndexToApproved;

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        pictureIndexToOwner[_tokenId] = _to;
        ownershipTokenCount[_to]++;

        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            delete pictureIndexToApproved[_tokenId];
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function _createPicture(address _creator, string _name, uint256 _hash, uint256 _frameSeed) internal returns (uint)
    {
        Picture memory _picture = Picture({
            creator: _creator,
            name: _name,
            creationTime: uint64(now),
            hash: _hash,
            frameSeed: _frameSeed
        });
        uint256 newPictureId = pictures.push(_picture) - 1;
        require(newPictureId == uint256(uint32(newPictureId)));

        emit PictureCreation(_creator, newPictureId, _hash, _frameSeed);

        _transfer(0, _creator, newPictureId);

        return newPictureId;
    }
}
