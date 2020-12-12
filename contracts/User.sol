// SPDX-License-Identifier: GPL-3.0

// pragma abicoder v2;
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.22 <0.8.0;

contract User{
    
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
    
    
    mapping ( string  => Details) public detailsMap;
    mapping ( string => Rides[]) finalBid;
    
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
    function set(string memory name,string memory username,string memory phoneNumber,string memory vehicle,string memory vehicleNo,string memory category,string memory password,string memory key,uint numberOfRides,uint reviewScore) public payable {
        string[] memory _reviewDescriptions;
        detailsMap[username]=Details(
            key,
            password,
            phoneNumber,
            vehicle,
            vehicleNo,
            name,
            category,
            numberOfRides=0,
            reviewScore=0,
            _reviewDescriptions
        );
        
    }
    
    function setFinalBid(string memory driver,string memory rider) public{
        finalBid[rider].push(Rides(driver));
    }
    function getFinalBid(string memory rider) public view returns(uint){
        return finalBid[rider].length;
    }
    
//    function showReviewScore(string memory username) view public returns (uint) {
//        return detailsMap[username].reviewScore;
//    }
      
//    function showReviewDescriptions(string memory username) view public returns (string[] memory) {
//        return detailsMap[username].reviewDescriptions;
//    }
}
