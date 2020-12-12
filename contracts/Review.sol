// SPDX-License-Identifier: GPL-3.0

// pragma abicoder v2;
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.8.0;

/** 
 * @title Review
 * @dev Implements ride share process and review system
 */
 
import './User.sol';

contract Review is User {
    struct RideReview {
        uint reviewScore;
        string reviewDescription;
        bool disputed;
        bool reviewConfirmed;
        bool discarded;
  }
  
  RideReview public review;
  
  // called by passenger (required)
  function writeReviewScore(uint score) payable public{
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
    User.Details storage driver = User.detailsMap[username];
    
    require(review.reviewConfirmed == true);
    if (review.discarded == false) {
        driver.numberOfRides += 1;
        // rating given by customer is from 0-5, we multiply it by 20 so that the score is from 0-100
        driver.reviewScore = ((driver.numberOfRides-1)*driver.reviewScore+20*review.reviewScore)/driver.numberOfRides;
        // driver.reviewScore = ((driver.numberOfRides-1)*driver.reviewScore+review.reviewScore)/driver.numberOfRides;
    
        driver.reviewDescriptions.push(review.reviewDescription);
    }
  }
  
  function showReviewScore(string memory username) view public returns (uint) {
    User.Details storage driver = User.detailsMap[username];
    return driver.reviewScore;
  }
      
  function showReviewDescriptions(string memory username) view public returns (string[] memory) {
    User.Details storage driver = User.detailsMap[username];
    return driver.reviewDescriptions;
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
