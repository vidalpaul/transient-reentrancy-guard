// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {TransientReentrancyGuard} from "../TransientReentrancyGuard.sol";

contract Client is TransientReentrancyGuard {
    error EthTransferFailed();

    mapping(address depositor => uint256 depositedAmount) internal deposits;

    receive() external payable {}

    function deposit() external payable {
        deposits[msg.sender] += msg.value;
    }

    function withdraw() external nonReentrant {
        (bool success,) = msg.sender.call{value: deposits[msg.sender]}("");
        if (!success) revert EthTransferFailed();

        delete deposits[msg.sender];
    }
}
