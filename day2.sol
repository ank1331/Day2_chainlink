pragma solidity ^0.8.0;

import "https://github.com/Chainlink-CCIP/cci-solidity/blob/main/contracts/CCIPLocalSimulator.sol";
import "https://github.com/Chainlink-CCIP/cci-solidity/blob/main/contracts/CrossChainNameServiceRegister.sol";
import "https://github.com/Chainlink-CCIP/cci-solidity/blob/main/contracts/CrossChainNameServiceReceiver.sol";
import "https://github.com/Chainlink-CCIP/cci-solidity/blob/main/contracts/CrossChainNameServiceLookup.sol";

contract TestCCNS {
    CCIPLocalSimulator simulator;
    CrossChainNameServiceRegister register;
    CrossChainNameServiceReceiver receiver;
    CrossChainNameServiceLookup lookupSource;
    CrossChainNameServiceLookup lookupReceiver;

    address aliceEOA = 0x...; // Replace with Alice's EOA address

    function setUp() public {
        // Create instances of smart contracts
        simulator = new CCIPLocalSimulator();
        register = new CrossChainNameServiceRegister();
        receiver = new CrossChainNameServiceReceiver();
        lookupSource = new CrossChainNameServiceLookup();
        lookupReceiver = new CrossChainNameServiceLookup();

        // Enable chains where needed
        register.enableChain();
        receiver.enableChain();

        // Set CrossChainNameService addresses
        lookupSource.setCrossChainNameServiceAddress(address(register));
        lookupReceiver.setCrossChainNameServiceAddress(address(receiver));
    }

    function testRegisterAndLookup() public {
        // Register "alice.ccns" with Alice's EOA address
        register.register("alice.ccns", aliceEOA);

        // Lookup "alice.ccns" and assert returned address is Alice's EOA address
        address returnedAddress = lookupSource.lookup("alice.ccns");
        assert(returnedAddress == aliceEOA);
    }
}
