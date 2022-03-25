//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract MyNFTERC721 is ERC721Enumerable, Ownable{

    //to count the token ID
    uint256 private _tokenIdCounter;


    //Mapping the token ID to baseURI
    mapping(uint256 => string) private _baseURIs;

    constructor(string memory _name, string memory _symbol) ERC721(_name,_symbol) {

    }
    function mint(string memory _tokenURI) public onlyOwner{
        
        require(keccak256(abi.encodePacked(_tokenURI)) !=  keccak256(abi.encodePacked("")),"Enter valid NFTURI");
        _tokenIdCounter++;
        _safeMint(msg.sender,_tokenIdCounter);
        _baseURIs[_tokenIdCounter] = _tokenURI;

    }


    function tokenURI(uint256 tokenId) public view  override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI(tokenId);
        return bytes(baseURI).length > 0 ? baseURI : "";
    }

    function _baseURI(uint _tokenId) internal view returns (string memory) {
        return _baseURIs[_tokenId];
    }

    
    
    

}