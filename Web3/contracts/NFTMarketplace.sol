// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/eRC721URISTORAGE.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 ListingPrice = 0.0015 ether;
    uint256 public minimumBidIncrement = 0.01 ether;

    address payable owner;
    mapping(uint256 => MarketItem) private idMarketItem;
    mapping(uint256 => mapping(address => uint256)) public offers;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
        bool isForSale;
        bool isAuction;
        uint256 auctionStartTime;
        uint256 auctionEndTime;
        address highestBidder;
        uint256 highestBid;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    event MarketItemSold(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 price
    );


    event OfferPlaced(
        uint256 indexed tokenId,
        address indexed bidder,
        uint256 amount
    );

    event OfferAccepted(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed bidder,
        uint256 amount
    );

    event AuctionCreated(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 durationInSeconds
    );

    event BidPlaced(
        uint256 indexed tokenId,
        address indexed bidder,
        uint256 amount
    );

    event BidWithdrawn(
        uint256 indexed tokenId,
        address indexed bidder,
        uint256 amount
    );

    event AuctionEnded(
        uint256 indexed tokenId,
        address indexed winner,
        uint256 amount
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner of contract or marketplace can change the listing price");
        _;
    }

    constructor() ERC721("NFT Metaverse Token", "MYNFT"){
        owner = payable(msg.sender);
    };


    function updateListingPrice(uint256 _ListingPrice) public payable onlyOwner
    {
        ListingPrice = _ListingPrice;
    }

    function getListingPrice() public view returns(uint256)
    {
        return ListingPrice;

        
    }

    // CREATE NFT FUNCTION TOKEN
    
    function createToken(string memory tokenURI, uint256 price ) 
        public 
        payable returns(uint256){
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        createMarkerItem(newTokenId, price);

        return newTokenId;

    }

// creating market item

    function createMarketItem(uint256 tokenId, uint256 price) private {
        require(price > 0, "Price must be atleast 1");
        require(msg.value == ListingPrice, "Price must be equal to Listing Price");

        idMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, addres(this), tokenId);

        emit MarketItemCreated(
            tokenId, 
            msg.msg.sender, 
            address(this), 
            price, 
            false
        );

    }

    // function for resale token

    function reSellToken(uint256 tokenId, uint256 price) public payable {
        require(idMarketItem[tokenId].owner == msg.sender, "Only Itme owner can perform this operation");
        require(msg.value == ListingPrice, "Price must be equal to listing price ");

        idMarketItem[tokenId].sold = false;
        idMarketItem[tokenId].price = price;
        idMarketItem[tokenId].seller = payable(msg.sender);
        idMarketItem[tokenId].owner = payable(address(this));

        _itemsSold.decrement();

        _transfer(msg.Senderm, address(this), tokenId);

    }

    // FUNCTION CREATEMARKETSALE

        function createMarketSale(uint256 tokenId) public payable {
        uint256 price = idMarketItem[tokenId].price;
        require(msg.value == price, "Please submit the asking price to complete the purchase");

        uint256 commission = price * 10 / 100; // Calculate 10% commission
        uint256 remainingAmount = price - commission; // Amount to be transferred to the seller

        idMarketItem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        idMarketItem[tokenId].owner = payable(address(0));

        _itemsSold.increment();

        _transfer(address(this), msg.sender, tokenId);

        payable(owner).transfer(commission); // Transfer commission to contract owner
        ayable(idMarketItem[tokenId].seller).transfer(remainingAmount); // Transfer remaining amount to the seller
        emit MarketItemSold(tokenId, msg.sender, price);
    }


    // GETTING UNSOLD NFT DATA

        function fetchMarketItem() public view returns(MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unSoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unSoldItemCount);
        for(uint256 i = 0; i<itemCount; i++){
            if(idMarketItem[i + 1].owner == addres(this)){
                uint256 currentId = i + 1;

                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;

    }

    // PURCHASE ITEM 
    
        function fetchMyNFT() public view returns(MarketItem[] memory){
            uint256 totalCount = _tokenIds.current();
            uint256 itemCount = 0;
            uint256 currentIndex = 0;

            for(uint256 i = 0; i < totalCount; i++){
                if(idMarketItem[i + 1].owner == msg.sender){
                    itemCount += 1;
                }
            }

            MarketItem[] memory items = new MarketItem[](itemCount);
            for(uint256 i = 0; i < totalCount; i++){
                if(idMarketItem[i + 1].owner == msg.sender){
                    uint256 currentId = i+1;
                    MarketItem storage currentItem = idMarketItem[currentId];
                    items[currentIndex] = currentItem;
                    currentIndex += 1;
                }
            }
            return items;

        } 

        // SINGLE USER ITEMS

        function fetchItemsListed() public view returns(MarketItem[] memory){
            uint256 totalCount = _tokenIds.current;
            uint256 itemCount = 0;
            uint256 currentIndex = 0;

            for(uint256 i = 0; i < totalCount; i++){
                if(idMarketItem[i + 1].seller == msg.sender){
                    itemCount +=1;
                }
            }

            MarketItem[] memory items = new MarketItem[](itemCount);
            for(uint256 i = 0; i < totalCount; i++){
                if(idMarketItem[i + 1].seller == msg.sender){
                    uint256 currentId = i+1;
                    MarketItem storage currentItem = idMarketItem[currentId];
                    items[currentIndex] = currentItem;
                    currentIndex += 1;
                }
            }
            return items;
        }

    // New function to make an offer on a listed item
    function makeOffer(uint256 tokenId) public payable {
        require(idMarketItem[tokenId].isForSale, "Item is not for sale");
        require(msg.value > 0, "Offer amount must be greater than 0");

        offers[tokenId][msg.sender] = msg.value;
        emit OfferPlaced(tokenId, msg.sender, msg.value);
    }

    // New function to accept an offer and transfer ownership
    function acceptOffer(uint256 tokenId, address bidder) public {
        require(ownerOf(tokenId) == msg.sender, "Only owner can accept offers");
        require(idMarketItem[tokenId].isForSale, "Item is not for sale");
        require(offers[tokenId][bidder] > 0, "No offer from this bidder");

        uint256 offerAmount = offers[tokenId][bidder];
        address seller = msg.sender;

        // Remove the offer and transfer ownership
        delete offers[tokenId][bidder];
        idMarketItem[tokenId].isForSale = false;
        _transfer(seller, bidder, tokenId);

        // Transfer funds to the seller
        seller.transfer(offerAmount);
        emit OfferAccepted(tokenId, seller, bidder, offerAmount);
    }
    
// Auction's code----->

    function createAuction(uint256 tokenId, uint256 durationInSeconds) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can start an auction");
        require(!idMarketItem[tokenId].isForSale, "Item is already listed for sale");
    
        idMarketItem[tokenId].isAuction = true;
        idMarketItem[tokenId].auctionStartTime = block.timestamp;
        idMarketItem[tokenId].auctionEndTime = block.timestamp + durationInSeconds;
        idMarketItem[tokenId].seller = payable(msg.sender);

        emit AuctionCreated(tokenId, msg.sender, durationInSeconds);
    }

    // Place Bids with Minimum Bid Increment
    function placeBid(uint256 tokenId) public payable {
        require(idMarketItem[tokenId].isAuction, "Item is not up for auction");
        require(block.timestamp < idMarketItem[tokenId].auctionEndTime, "Auction has ended");
        require(msg.value >= idMarketItem[tokenId].highestBid + minimumBidIncrement, "Bid must be higher than current highest bid plus minimum increment");

        // If there was a previous highest bidder, refund their bid
        if (idMarketItem[tokenId].highestBidder != address(0)) {
            pendingReturns[idMarketItem[tokenId].highestBidder] += idMarketItem[tokenId].highestBid;
        }

        idMarketItem[tokenId].highestBidder = msg.sender;
        idMarketItem[tokenId].highestBid = msg.value;

        emit BidPlaced(tokenId, msg.sender, msg.value);
    }

    // Withdraw Bids
    function withdrawBid(uint256 tokenId) public {
        require(idMarketItem[tokenId].isAuction, "Item is not up for auction");
        require(block.timestamp < idMarketItem[tokenId].auctionEndTime, "Auction has ended");
        require(msg.sender == idMarketItem[tokenId].highestBidder, "Only highest bidder can withdraw");

        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            payable(msg.sender).transfer(amount);
            emit BidWithdrawn(tokenId, msg.sender, amount);
        }
    }

    // End Auction
    function endAuction(uint256 tokenId) public {
        require(idMarketItem[tokenId].isAuction, "Item is not up for auction");
        require(block.timestamp >= idMarketItem[tokenId].auctionEndTime, "Auction is still active");

        address highestBidder = idMarketItem[tokenId].highestBidder;
        uint256 highestBid = idMarketItem[tokenId].highestBid;

        // Clear auction data
        idMarketItem[tokenId].isAuction = false;
        idMarketItem[tokenId].auctionStartTime = 0;
        idMarketItem[tokenId].auctionEndTime = 0;
        idMarketItem[tokenId].highestBidder = address(0);
        idMarketItem[tokenId].highestBid = 0;

        // Transfer NFT to highest bidder
        _transfer(msg.sender, highestBidder, tokenId);

        // Pay the seller and the platform fee
        uint256 commission = highestBid * 10 / 100; // 10% commission
        uint256 sellerAmount = highestBid - commission;

        payable(idMarketItem[tokenId].seller).transfer(sellerAmount);
        payable(owner).transfer(commission);

        emit AuctionEnded(tokenId, highestBidder, highestBid);
    }

    function _isTokenInAuction(uint256 tokenId) private view returns (bool) {
        return idMarketItem[tokenId].isAuction && block.timestamp < idMarketItem[tokenId].auctionEndTime;
    }
}


