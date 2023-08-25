// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectName = "Dogie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(expectName)) == keccak256(abi.encodePacked(actualName)));
        // assert(abi.encodedpack(expectName) == actualName);
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assert(basicNft.balanceOf(USER) == 1);
    }

    function testOwnerofNft() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assertEq(basicNft.ownerOf(0), USER);
    }

    function testTokenUriIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assertEq(keccak256(abi.encodePacked(basicNft.tokenURI(0))), keccak256(abi.encodePacked(PUG_URI)));
    }

    function testTokenCounter() public {
        uint256 startTokenCounter = basicNft.getTokenCounter();
        vm.prank(USER);
        MintBasicNft mintNft = new MintBasicNft();
        mintNft.mintNftOnContract(address(basicNft));
        assertEq(basicNft.getTokenCounter(), startTokenCounter + 1);
    }
}
