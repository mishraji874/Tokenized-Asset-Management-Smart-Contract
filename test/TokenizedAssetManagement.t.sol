// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenizedAssetManagement.sol";

contract TokenizedAssetManagementTest is Test {
    TokenizedAssetManagement public tam;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        tam = new TokenizedAssetManagement();
    }

    function testCreateAsset() public {
        uint256 totalSupply = 1000;
        uint256 price = 1 ether;
        string memory uri = "https://example.com/asset/1";

        tam.createAsset(totalSupply, price, uri);

        (address assetOwner, uint256 assetTotalSupply, uint256 assetRemainingSupply, uint256 assetPrice, string memory assetUri) = tam.tokenizedAssets(1);

        assertEq(assetOwner, owner);
        assertEq(assetTotalSupply, totalSupply);
        assertEq(assetRemainingSupply, totalSupply);
        assertEq(assetPrice, price);
        assertEq(assetUri, uri);
    }

    function testFailCreateAssetNonOwner() public {
        vm.prank(user1);
        tam.createAsset(1000, 1 ether, "https://example.com/asset/2");
    }

    function testTransferOwnership() public {
        uint256 totalSupply = 1000;
        uint256 price = 1 ether;
        string memory uri = "https://example.com/asset/3";

        tam.createAsset(totalSupply, price, uri);

        uint256 amountToTransfer = 500;
        tam.transferOwnership(1, user1, amountToTransfer);

        (, , uint256 remainingSupply, , ) = tam.tokenizedAssets(1);
        uint256 user1Balance = tam.fractionalOwnership(1, user1);

        assertEq(remainingSupply, totalSupply - amountToTransfer);
        assertEq(user1Balance, amountToTransfer);
    }

    function testFailTransferOwnershipNonOwner() public {
        tam.createAsset(1000, 1 ether, "https://example.com/asset/4");

        vm.prank(user1);
        tam.transferOwnership(1, user2, 500);
    }

    function testFailTransferOwnershipInsufficientBalance() public {
        tam.createAsset(1000, 1 ether, "https://example.com/asset/5");
        tam.transferOwnership(1, user1, 1500);
    }

    function testFractionalOwnership() public {
        tam.createAsset(1000, 1 ether, "https://example.com/asset/6");
        tam.transferOwnership(1, user1, 300);
        tam.transferOwnership(1, user2, 200);

        assertEq(tam.fractionalOwnership(1, user1), 300);
        assertEq(tam.fractionalOwnership(1, user2), 200);
    }

    function testTokenURI() public {
        string memory uri = "https://example.com/asset/7";
        tam.createAsset(1000, 1 ether, uri);

        assertEq(tam.tokenURI(1), uri);
    }

    function testNextTokenId() public {
        assertEq(tam.nextTokenId(), 1);

        tam.createAsset(1000, 1 ether, "https://example.com/asset/8");
        assertEq(tam.nextTokenId(), 2);

        tam.createAsset(2000, 2 ether, "https://example.com/asset/9");
        assertEq(tam.nextTokenId(), 3);
    }
}