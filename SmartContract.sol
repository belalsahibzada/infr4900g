// SPDX-License-Identifier: MIT
pragma solidity ^0.6.4;

contract SupplyChain{
    address payable owner; //address is data type (like int), which stores only addresses; owner is the variable
    constructor() public {
        owner = msg.sender; //person who initiated the contract is the owner using built in variable msg.sender
    }
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function!"); //allows only the owner to call this function
        _; //code before this will run before the functions code, and any code after it will run after the functions code
    }
}

contract supplyChainContract is SupplyChain {
    mapping(uint => uint) public deliveryStatus; // For example 0 = Not Delivered, 1 = Delivered, 2 = Status Pending
    event releasePayment(uint productID, address recipient, uint amount);
    event updateDeliveryStatus(uint productID, uint status);

    function confirmDelivery(uint productID, uint status) public {
        require(msg.sender == owner,"Must be owner to update status");
        require(status <= 2);//ensure status is either 0,1,2 
        deliveryStatus[productID] = status; //update status
        emit updateDeliveryStatus(productID, status);
    }
    function sendPayment(uint productID, address payable recipient, uint amount) public {
        require(deliveryStatus[productID] == 1); //product must be delivered, otherwise don't send payment
        recipient.transfer(amount);
        emit releasePayment(productID, recipient, amount);
    }
    function depositFunds() public payable {}
}

//ensure that only the owner can delete the contract
contract verifyOwner is supplyChainContract {
    //destructor to allow only owner to delete the contract
    function destroy() public onlyOwner{
        selfdestruct(owner);
    }
}
