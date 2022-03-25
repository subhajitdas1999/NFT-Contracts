//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyNFTERC721A is ERC721A,Ownable{

    //maximum minting amount at a time
    uint private _maxMintAmount = 10;
    uint private _mintRate = 0.00001 ether;

    constructor(string memory name_, string memory symbol_) ERC721A(name_,symbol_){
        
    }

    function safeMint(uint _mintAmount) public payable{
        require(msg.value >= _mintRate * _mintAmount,"Not enough ether sent");
        require(_mintAmount<=_maxMintAmount,"maximum you can mint 10 NFTs");
        _safeMint(msg.sender,_mintAmount);
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function withDrawEther() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }



    
}
