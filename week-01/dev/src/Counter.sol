// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Counter {
    uint256 public count;

    function getCount() public view returns (uint256) {
        return count;
    }

    function increment() public {
        count += 1;
    }

    function decrement() public {
        require(count > 0, "Count cannot go below zero");
        count -= 1;
    }

    function reset() public {
        count = 0;
    }
}
