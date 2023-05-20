// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//note : the overriding function needs to have the same function name and the same number of arguments and types as in the parent class. 

//Soulboundtoken tutorial
//https://www.youtube.com/watch?v=90vWC4Z8aPo

contract SoulBoundToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("SoulBoundToken", "SBT") {}

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    //ERC721 BeforeTransfer and AfterTransfer functions act as hooks for things that happen before and after transfers
     
    //Override ERC721 _beforeTokenTransfer function so that these nfts cannot be transferred 
    function _beforeTokenTransfer(address from, address to, uint256 /*firstTokenId*/, uint256 /*batchSize*/) internal override virtual {
        //If user is buring the token or recieving the token let it go through. Else don't allow
        //From address 0 -> receiving/minting
        //to address 0 -> burning
        require(from == address(0) || to == address(0), "You Cannot Transfer this token");

    }
//emit event Transfer if we burn or mint
     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 /*batchSize*/) internal override virtual {
        if(from == address(0) || to == address(0)){
            emit Transfer(from, to, firstTokenId);
        }

     }


    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only the Owner of the token may burn it");
        _burn(tokenId);
    }

    function revoke(uint256 tokenId) onlyOwner external {
        _burn(tokenId);
    }


}