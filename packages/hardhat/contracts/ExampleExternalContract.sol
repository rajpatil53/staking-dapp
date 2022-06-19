// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ExampleExternalContract is Ownable {
    bool public completed;
    address public stakerContractAddress;

    function complete() public payable {
        completed = true;
    }

    function transferFunds() public {
        require(msg.sender != address(0), "Staker contract address not set.");
        require(
            msg.sender == stakerContractAddress,
            "Only staker contract can transfer funds."
        );
        require(completed, "Stake not completed.");

        completed = false;
        (bool sent, bytes memory data) = stakerContractAddress.call{
            value: address(this).balance
        }("");
        require(sent, "Failed to send Ether");
    }

    function setStakerContractAddress(address _stakerContractAddress)
        public
        onlyOwner
    {
        stakerContractAddress = _stakerContractAddress;
    }
}
