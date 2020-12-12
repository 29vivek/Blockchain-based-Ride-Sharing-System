pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;
// import "remix_tests.sol"; // this import is automatically injected by Remix.
// import "remix_accounts.sol";
// import "./test.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts

//import "remix_tests.sol"; // this import is automatically injected by Remix.
// import "Review.sol";
// import "User.sol";

import "../contracts/Review.sol";
// import "../contracts/User.sol";

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract ReviewTest {

    Review reviewToTest;
    // User userToTest;

    string[] public description_array; // for testing description

   // function beforeAll () public {
       // reviewToTest = new Review();
       // userToTest = new User();
   // }

    function testWriteReviewScore () public{
        reviewToTest = new Review();
        reviewToTest.writeReviewScore(uint(4));
        Assert.equal(reviewToTest.getScore(), uint(4), "The review score should be 4");
    }

    function testWriteReviewDescription () public{
        reviewToTest = new Review();
        reviewToTest.writeReviewDescription(string("The driver is punctuate and I enjoy the ride"));
        Assert.equal(reviewToTest.compareStrings(reviewToTest.getDescription(), string("The driver is punctuate and I enjoy the ride")), true,
                    "The comment should be: The driver is punctuate and I enjoy the ride");
                    
    }

    function testShowReviewScore () public payable returns (bool){
        reviewToTest = new Review();
        reviewToTest.set(string("Alice"),string("alice101"),string("666-666-6666"),string("Lexus"),
                          string("AZ2345"),string("driver"),string("12345678"),string("abc"),
                          uint(3),uint(80));

        reviewToTest.writeReviewScore(uint(2));
        reviewToTest.writeReviewDescription(string("I don't like this driver"));
        reviewToTest.confirmedReview();
        reviewToTest.updateReview(string("alice101"));
        Assert.equal(reviewToTest.showReviewScore(string("alice101")), uint(70), "The updated score should be 70");
    }

    function testShowReviewDescription () public payable returns (bool){
        reviewToTest = new Review();
        reviewToTest.set(string("Bob"),string("bob999"),string("222-888-5555"),string("Nissan"),
                          string("ILL7081"),string("driver"),string("abcdefgh"),string("234"),
                          uint(0),uint(0));
        reviewToTest.writeReviewScore(uint(4));
        reviewToTest.writeReviewDescription(string("I really enjoy the ride"));
        reviewToTest.confirmedReview();
        reviewToTest.updateReview(string("bob999"));

        description_array.push(string("I really enjoy the ride"));

        Assert.equal(reviewToTest.compareListStrings(reviewToTest.showReviewDescriptions(string("bob999")), description_array), true,
                     "The comments should be: [I really enjoy the ride]" );

    }

    function testDisputeDiscard () public {
        reviewToTest = new Review();
        reviewToTest.set(string("Alice"),string("alice101"),string("666-666-6666"),string("Lexus"),
                          string("AZ2345"),string("driver"),string("12345678"),string("abc"),
                          uint(3),uint(80));

        reviewToTest.writeReviewScore(uint(0));
        reviewToTest.writeReviewDescription(string("This driver is sh*t!"));
        reviewToTest.disputeReview();
        reviewToTest.discardReview();
        reviewToTest.confirmedReview();
        reviewToTest.updateReview(string("alice101"));
        Assert.equal(reviewToTest.showReviewScore(string("alice101")), uint(80), "The update score should be 80");

    }
}


