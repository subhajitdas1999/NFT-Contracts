//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MyMarketPlace{
    
    //account that going to recieve fees over tx
    address payable private immutable _feeReciever;

    //fee percent, going to add on each item
    uint private immutable feePercent;

    //minimum price for listing an NFT
    uint private minListingPrice= 0.00001 ether;

    //contains details of one item
    struct Item{
        uint itemId;
        IERC721 contractAddress;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }
    //works as a ID for each item
    uint private _itemcounter;

    //mapps each item with a token itemId
    mapping(uint => Item) public items;

    //mapping [contractAddress][tokenId] => itemID to prevent duplicate listing
    

    //event for item listing 
    event listed(uint itemId, IERC721 contractAddress, uint tokenId,uint price ,address seller);
    //event for item purchsed
    event purchsed(uint itemId,IERC721 contractAddress, uint tokenId,address from,uint price);

    constructor (uint _feePersent){
        _feeReciever = payable(msg.sender);
        feePercent = _feePersent;
    }

    function listNFTforSale(uint _price,IERC721 _contractAddress ,uint _tokenId) public{
        require(_price > minListingPrice,"minimum listing price is 0.00001 ether");
        require(_contractAddress.ownerOf(_tokenId) == msg.sender,"Owner is  required for listing");
        require(_contractAddress.isApprovedForAll(msg.sender,address(this)),"Owner should approved this marketPlace as a operator before listings");
        
        _itemcounter++;
        Item memory item = Item(
            _itemcounter,
            _contractAddress,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );

        items[_itemcounter] = item;

        emit listed(_itemcounter,_contractAddress,_tokenId,_price,msg.sender);
    }

    function buyNFT(uint _itemId) public payable{
        require(_itemId<=_itemcounter,"NFT is not exist");
        require(!items[_itemId].sold ,"This NFT is already sold");

        //getting the amount required including percentage fee
        uint requiredAmount = getAmount(_itemId);

        require(msg.value >= requiredAmount,"send more ether");

        Item storage item = items[_itemId];

        // transfering the NFT to the buyer
        item.contractAddress.transferFrom(item.seller,msg.sender,item.tokenId);

        //marking the item as sold
        item.sold = true;

        //forward the fund to fee reciever
        _forwardFunds();

        emit purchsed(_itemId,item.contractAddress, item.tokenId,item.seller,requiredAmount);

    }

    function getAmount(uint _itemId) private view returns(uint){         
        uint  price = items[_itemId].price;
        return (price * feePercent) / 100;
    }

    function _forwardFunds() private {
        _feeReciever.transfer(msg.value);
    }
}