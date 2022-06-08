// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    //To keep tract of who sent us some money
    mapping(address => uint256) public addressToAmountFunded;
     address public owner;  
     address[] public funders;

    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) {
      priceFeed = AggregatorV3Interface(_priceFeed);
      owner = msg.sender;

    }
    function fund() public payable{
      //$50
      uint256 minimumUSD = 50 * 10 * 18;
      require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
      //Above we multiplied the 50 to 10 raised to 18 to do work in Gwei

        addressToAmountFunded[msg.sender] += msg.value;
        //what the ETH -> USD conversion rate
        funders.push(msg.sender);
    }
    function getVersion() public view returns (uint256){
       return priceFeed.version();
    }
    function getPrice() public view returns (uint256){
      
      (,int256 answer,,,) = priceFeed.latestRoundData();
      return uint256(answer * 10000000000);
      // 2,932.41000000
    }
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
      uint256 ethPrice = getPrice();
      uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
      return ethAmountInUsd;
      //0.000002932410000000
    }  
    function getEntranceFee() public view returns (uint256){
      uint256 minimumUSD = 50 * 10 ** 18;
      uint256 price = getPrice();
      uint256 precision = 1 * 10**18;
      return (minimumUSD * precision) / price;
    }

    modifier onlyOwner {
      require(msg.sender == owner, "Not the owner");
      _;
    }
    function withdraw() payable onlyOwner public {
      //only want contract admin/owner
      payable(msg.sender).transfer(address(this).balance);
      for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;

      }
      funders = new address[](0);
    } 
}