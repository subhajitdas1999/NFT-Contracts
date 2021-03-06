//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyNFTERC1155 is ERC1155,Ownable{
    constructor() ERC1155("https://token-cdn-domain/{id}.json"){

    }

    // provide the tokenID and the amount to mint 
    function mint(uint _id, uint _tokenAmount) public onlyOwner{
        _mint(msg.sender,_id,_tokenAmount,"");
    }

    // provide the array of IDs([1,2,3]) and corresponding array of tokenAmounts ([50,1,10**18])
    function mintBatch(uint256[] memory _ids,uint256[] memory _tokensAmounts) public onlyOwner{
        _mintBatch(msg.sender,_ids,_tokensAmounts,"");
    }

    
}