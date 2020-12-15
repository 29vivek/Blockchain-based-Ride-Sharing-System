// SPDX-License-Identifier: GPL-3.0

// pragma abicoder v2;
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.8.0;

/** 
 * @title Review
 * @dev Implements ride share process and review system
 */
 
// import './User.sol';

// contract Review is User {
contract Review {
    struct RideReview {
        uint reviewScore;
        string reviewDescription;
        bool disputed;
        bool reviewConfirmed;
        bool discarded;
  }
  
    // Details about the driver
    struct Details{
    
        string privateKey;
        string password;
        string phoneNumber;
        string vehicle;
        string vehicleNo;
        string name;
        string category;
        uint numberOfRides; // inital value: 0
        uint reviewScore; // initial value: 0
        string[] reviewDescriptions; // initial value: [""]
    
    }
    
    struct Rides{
        string driver;
    }
  
    RideReview public review;
    mapping ( string  => Details) public detailsMap;
    mapping ( string => Rides[]) finalBid;
    
    /* Functions for the driver object */
    function get(string memory username) public view returns(string memory,string memory,string memory,string memory,string memory,string memory,string memory,uint,uint,string[] memory){
    
        Details memory currentUser=detailsMap[username];
        return (
           
            currentUser.privateKey,
            currentUser.phoneNumber,
            currentUser.vehicle,
            currentUser.vehicleNo,
            currentUser.category,
            currentUser.name,
            currentUser.password,
            currentUser.numberOfRides,
            currentUser.reviewScore,
            currentUser.reviewDescriptions
            
        );
    
    }
    function set(string memory name,string memory username,string memory phoneNumber,string memory vehicle,string memory vehicleNo,string memory category,string memory password,string memory key,uint numberOfRides,uint reviewScore) public payable{
        string[] memory _reviewDescriptions;
        detailsMap[username]=Details(
            key,
            password,
            phoneNumber,
            vehicle,
            vehicleNo,
            name,
            category,
            numberOfRides,
            reviewScore,
            _reviewDescriptions
        );
    }
    
    function setFinalBid(string memory driver,string memory rider) public{
        finalBid[rider].push(Rides(driver));
    }
    function getFinalBid(string memory rider) public view returns(uint){
        return finalBid[rider].length;
    }
    
    
    function getScore(string memory username) view public returns (uint) {
        Details memory currentUser=detailsMap[username];
        return currentUser.reviewScore;
    }
    
    function getNumberOfRides(string memory username) view public returns (uint) {
        Details memory currentUser=detailsMap[username];
        return currentUser.numberOfRides;
    }
  
  /* Functions for the review object */
  // called by passenger (required)
  function writeReviewScore(uint score) payable public {
    review.reviewScore = score;
    review.disputed = false;
    review.reviewConfirmed = false;
    review.discarded = false;
  }
  
  function getScore() view public returns (uint){
      return review.reviewScore;
  }
  
  // called by passenger (optional)
  function writeReviewDescription(string memory description) payable public{
    review.reviewDescription = description;
  }
  
  // (optional)
  function getDescription() view public returns (string memory) {
      return review.reviewDescription;
  }
  
  // called by driver (optional)
  function disputeReview() payable public{
      review.disputed = true;
  }
  
  // called by other users (optional)
  function discardReview() payable public{
      review.discarded = true;
  }
  
  // called by other users (either driver or passenger)
  function confirmedReview() payable public {
    if (review.disputed == true) {
      // discard review or not 
      if (review.discarded == true) {
        uint emptyReviewScore;
        string memory emptyReviewDescription;
        review.reviewScore = emptyReviewScore;
        review.reviewDescription = emptyReviewDescription;
      }
    }
    else {
      review.discarded = false;
    }
    review.reviewConfirmed = true;
  }
  
  function updateReview(string memory username) payable public{
    // User.Details storage driver = User.detailsMap[username];
    Details storage driver = detailsMap[username];
    
    require(review.reviewConfirmed == true);
    if (review.discarded == false) {
        // driver.numberOfRides += 1;
        // // rating given by customer is from 0-5, we multiply it by 20 so that the score is from 0-100
        // driver.reviewScore = ((driver.numberOfRides-1)*driver.reviewScore+20*review.reviewScore)/driver.numberOfRides;
        // driver.reviewDescriptions.push(review.reviewDescription);
        
        uint currNumberOfRides = driver.numberOfRides + 1;
        // rating given by customer is from 0-5, we multiply it by 20 so that the score is from 0-100
        uint updatedReviewScore = ((currNumberOfRides-1)*driver.reviewScore+20*review.reviewScore)/currNumberOfRides;
        driver.reviewDescriptions.push(review.reviewDescription);
        
        detailsMap[username].numberOfRides = currNumberOfRides;
        detailsMap[username].reviewScore = updatedReviewScore;
        detailsMap[username].reviewDescriptions = driver.reviewDescriptions;
    }
  }
  
  function showReviewScore(string memory username) view public returns (uint) {
    // User.Details storage driver = User.detailsMap[username];
    Details storage driver = detailsMap[username];
    return driver.reviewScore;
  }
      
  function showReviewDescriptions(string memory username) view public returns (string[] memory) {
    // User.Details storage driver = User.detailsMap[username];
    Details storage driver = detailsMap[username];
    return driver.reviewDescriptions;
  }
  
  // helper function
  function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
  
  // helper function
  function compareListStrings(string[] memory _a, string[] memory _b) public pure returns (bool) {
      bool same = true;
      if (_a.length != _b.length) {
          same = false;
      }
      for (uint i=0; i < _a.length; i++) {
          if (compareStrings(_a[i], _b[i]) == false) {
              same = false;
          }
      }
      return same;
  }

  
//   function showReviewScore(string memory username) pure public returns (uint) {
//     User.Details storage driver = User.detailsMap[username];
//     return driver.reviewScore;
//   }
  
//   function showReviewDescriptions(string memory username) pure public returns (string[] memory) {
//     User.Details storage driver = User.detailsMap[username];
//     return driver.reviewDescriptions;
//   }
  
}


