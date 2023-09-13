// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Owned.sol";

contract OwnedTestHelper is Owned {
    event Here();

    function modifierOnlyOwner() public onlyOwner {
        emit Here();
    }
}
