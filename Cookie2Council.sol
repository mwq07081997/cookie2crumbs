// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0; // change to appropriate 

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// child contract
contract Cookie2Council is Ownable, Pausable{

    string public name;

    constructor(string memory _name) {  
      name = _name;
    }

    //string transaction_ide;
    mapping(address => bool) whitelistedAddresses;

    address[] public list_of_addresses; //array to get list of addresses

    // modifier for whitelisted address's function calls
    modifier isWhitelisted(address _address) {
      require(whitelistedAddresses[_address], "Whitelist: You need to be whitelisted");
      _;
    }

    function addUser(address _addressToWhitelist) external onlyOwner {
      whitelistedAddresses[_addressToWhitelist] = true;
      list_of_addresses.push(_addressToWhitelist);
    }

    function removeUser(address _addressToWhitelist) external onlyOwner {
      whitelistedAddresses[_addressToWhitelist] = false;
    }

    function verifyUser(address _whitelistedAddress) public view returns(bool) {
      bool userIsWhitelisted = whitelistedAddresses[_whitelistedAddress];
      return userIsWhitelisted;
    }

    // call to main contract to save logs
    function logSignatures(address _contract, string[] calldata transaction_ids) external payable isWhitelisted(msg.sender) {
        // A's storage is set, B is not modified.
        string calldata transaction_id;

        (bool success, bytes memory data) = _contract.call(
            abi.encodeWithSignature("logSignatures(string[])", transaction_ids)
        );

        require (success, "delegate call failed");
    }

    function pause() public isWhitelisted(msg.sender) {
        _pause();
    }

    function unpause() public isWhitelisted(msg.sender) {
        _unpause();
    }
    
}
