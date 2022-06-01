// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../BadgeRenderer.sol";
import "../renoun.sol";

contract RenounTest is Test {
    Renoun renoun;
    BadgeRenderer renderer;
    address tester = address(1);

    function setUp() public {
        renderer = new BadgeRenderer();
    }

    function testCanDeploy() public {
        renoun = new Renoun(
            "renoun",
            "Jon-Becker",
            "Renoun",
            "$RENOUN",
            address(renderer)
        );
    }

    function testIsSoulbound() public {
        renoun = new Renoun(
            "renoun",
            "Jon-Becker",
            "Renoun",
            "$RENOUN",
            address(renderer)
        );
        renoun.mint(
            tester,
            1,
            "Test",
            1,
            300,
            "https://picsum.photos/200",
            "Test User",
            "2164c6505b07dcaddce3f63d1b34583502eb26f9",
            300,
            100
        );
        startHoax(tester, 1);
        assertEq(renoun.balanceOf(tester), 1);
        assertEq(renoun.ownerOf(1), tester);
        vm.expectRevert("Renoun: Transfer not supported.");
        renoun.safeTransferFrom(tester, address(0xdead), 1);
        vm.expectRevert("Renoun: Transfer not supported.");
        renoun.safeTransferFrom(tester, address(0xdead), 1, bytes("random"));
        vm.expectRevert("Renoun: Transfer not supported.");
        renoun.transferFrom(tester, address(0xdead), 1);
        vm.expectRevert("Renoun: Approval not supported.");
        renoun.approve(address(0xdead), 1);
        vm.expectRevert("Renoun: Approval not supported.");
        renoun.setApprovalForAll(address(0xdead), true);
        vm.stopPrank();

        assertEq(renoun.getApproved(1), address(0x0));
        assertEq(renoun.isApprovedForAll(tester, address(0xdead)), false);

        // Code from: https://github.com/m1guelpf/soulminter-contracts/blob/6aa882eb12e306c0774f25f2dd234fe930e9b00f/test/Soulminter.t.sol#L63
        assertTrue(renoun.supportsInterface(0x01ffc9a7));
        assertTrue(renoun.supportsInterface(0x80ac58cd));
        assertTrue(renoun.supportsInterface(0x5b5e139f));
    }
}
