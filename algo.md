1. Assume all the drivers and passengers registered and their identity verified

2. A passenger wants a ride by submitting a transaction request via our application and this request is viewable (or broadcasted) to all the people in the network. This request contains detailed info of the passenger's request (starting point and destination, number of passengers), and his/her ideal price. A passenger also deposits his/her money into the system first, in case that driver gain no money when passenger does not show up at the pick-up location

3. Interested drivers in this area reply to this request (this process takes up to 5 min). If after 5 min, no driver responds then it means there is no drivers available right now. The request will be denied and the passenger may choose to submit a request later. 

4. Available drivers respond to the request with his/her ideal price and also his promise arrival time (not a clock time but a duration so that it starts to count down after passenger decides to choose this driver). Drivers can also see a suggested minimum price given by the system. The system generates this model by training open-source Uber/Lift pricing data. This minimum suggested prices does not affect the final transaction price at all. It is just telling drivers that they will earn more if they were employeed by Uber/Lift than they take this order in our ride-sharing system.

5. Passenger himself/herself selects a driver who charges lowest price and promises shortest arrival time in 5 min. Count down start for the selected driver and the ride request node is mined by the passenger. 

6. When the ride is completed, driver submits a new node called "ride completed and request for payment". A miner (nor driver or passenger in this transaction) will verify this "transaction completed" by judging 1. driver arrives in time as promised, 2. passenger confirms he/she arrives at his/her destination. If both condition 1 and condition 2 satisfied, the driver gets the deposited money. If condition 1 not satisfied but condition 2 is satisfied, the driver still gains some money but not the full amount. If neither of the conditions is satisfied, the driver gain no money and the money is returned. The money is allocated by **smart contract** once this node is verified.

7. After a transaction, customer may choose to submit a review. The review contains two part: a score (required) and descriptions(optional). 

8. Drivers can dispute about passenger not confirming a completed ride by submitting a dispute node. A miner (third party) will review this dispute and consider whether driver's argument as well as his/herp provided proof are valid. Drivers must submit this dispute within 24 hours (as what happens in Uber.) 24 hours later the deposited money will return to the passenger so a dispute after that is invalid. The miner get some rewards (money) by doing so.

9. Drivers can dispute about a review. Driver submits a dispute request by submitting a dispute node. A miner (third party) will review this dispute and consider whether or not to dicard this review. So far, we define the criteria as if the review contains swear words. The miner get some rewards (money) by doing so.

things to consider / future work:

1. Smart contract can help notifying free drivers in the area when a new request is created

2. average review score, badge (not nesscessary?)

3. Drivers can dispute about a review. Driver submits a dispute request. A miner will review this dispute and consider whether or not to dicard this review. 

4. transaction - not just bitcoin, support other transaction

5. phone number, how drivers contact?

edge case:

1. Passenger not show up (considered, solve by deposit first rule)

2. Driver never arrives (considered, solve by arrival time constraint)

3. 

