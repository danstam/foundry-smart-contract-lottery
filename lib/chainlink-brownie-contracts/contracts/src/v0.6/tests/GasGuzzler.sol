// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract GasGuzzler {
    fallback() external payable {
        while (true) {}
    }
}
