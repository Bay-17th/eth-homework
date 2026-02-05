// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "../src/SimpleStorage.sol";

/// @title SimpleStorageTest - Week 2 테스트
/// @notice 이 테스트들이 모두 통과하도록 SimpleStorage.sol의 TODO를 구현하세요
/// @dev Foundry의 고급 테스트 기능(cheatcode, fuzz)을 학습합니다
contract SimpleStorageTest is Test {
    // ============================================================
    // 테스트 상태 변수
    // ============================================================

    /// @notice 테스트할 SimpleStorage 컨트랙트 인스턴스
    SimpleStorage public simpleStorage;

    /// @notice 테스트에 사용할 사용자 주소
    address public user = address(0x1234);

    // ============================================================
    // setUp 함수
    // ============================================================

    /// @notice 각 테스트 전에 실행되는 설정 함수
    /// @dev 새로운 SimpleStorage 인스턴스를 생성하고 테스트 계정에 ETH를 지급합니다
    function setUp() public {
        // 새로운 SimpleStorage 컨트랙트 배포
        simpleStorage = new SimpleStorage();

        // vm.deal: 테스트 계정에 ETH 지급 (cheatcode)
        // user 주소에 10 ETH를 지급합니다
        vm.deal(user, 10 ether);
    }

    // ============================================================
    // 입금(Deposit) 테스트
    // ============================================================

    /// @notice deposit 함수가 잔액을 올바르게 업데이트하는지 확인합니다
    function test_Deposit_UpdatesBalance() public {
        // Arrange: user가 호출하도록 설정
        // vm.prank: 다음 호출의 msg.sender를 변경 (cheatcode)
        vm.prank(user);

        // Act: 1 ETH 입금
        simpleStorage.deposit{value: 1 ether}();

        // Assert: 잔액이 1 ETH인지 확인
        assertEq(
            simpleStorage.getBalance(user),
            1 ether,
            "Balance should be 1 ether after deposit"
        );
    }

    /// @notice deposit 함수가 Deposited 이벤트를 발생시키는지 확인합니다
    function test_Deposit_EmitsEvent() public {
        // Arrange: user가 호출하도록 설정
        vm.prank(user);

        // vm.expectEmit: 다음 호출에서 특정 이벤트가 발생할 것을 예상
        // (checkTopic1, checkTopic2, checkTopic3, checkData)
        // true = 해당 항목을 검증함
        vm.expectEmit(true, false, false, true);

        // 예상되는 이벤트 (비교 대상)
        emit SimpleStorage.Deposited(user, 1 ether);

        // Act: 1 ETH 입금 - 이 호출에서 이벤트가 발생해야 함
        simpleStorage.deposit{value: 1 ether}();
    }

    // ============================================================
    // 출금(Withdraw) 테스트
    // ============================================================

    /// @notice withdraw 함수가 잔액을 올바르게 업데이트하는지 확인합니다
    function test_Withdraw_UpdatesBalance() public {
        // Arrange: 먼저 2 ETH 입금
        vm.prank(user);
        simpleStorage.deposit{value: 2 ether}();

        // Act: 1 ETH 출금
        vm.prank(user);
        simpleStorage.withdraw(1 ether);

        // Assert: 잔액이 1 ETH인지 확인
        assertEq(
            simpleStorage.getBalance(user),
            1 ether,
            "Balance should be 1 ether after withdrawing 1 from 2"
        );
    }

    /// @notice withdraw 함수가 ETH를 실제로 전송하는지 확인합니다
    function test_Withdraw_TransfersEther() public {
        // Arrange: user의 초기 ETH 잔액 기록 (vm.deal로 10 ETH 지급됨)
        uint256 initialBalance = user.balance;

        // 2 ETH 입금
        vm.prank(user);
        simpleStorage.deposit{value: 2 ether}();

        // 입금 후 user의 ETH 잔액 (10 - 2 = 8 ETH)
        uint256 afterDepositBalance = user.balance;
        assertEq(afterDepositBalance, initialBalance - 2 ether);

        // Act: 1 ETH 출금
        vm.prank(user);
        simpleStorage.withdraw(1 ether);

        // Assert: user의 ETH 잔액이 1 ETH 증가했는지 확인
        assertEq(
            user.balance,
            afterDepositBalance + 1 ether,
            "User should receive 1 ether back"
        );
    }

    /// @notice 잔액보다 많은 금액을 출금하려고 하면 revert되는지 확인합니다
    function test_RevertWhen_WithdrawExceedsBalance() public {
        // Arrange: 1 ETH 입금
        vm.prank(user);
        simpleStorage.deposit{value: 1 ether}();

        // vm.expectRevert: 다음 호출이 revert될 것을 예상
        vm.expectRevert("Insufficient balance");

        // Act: 2 ETH 출금 시도 (잔액 1 ETH보다 많음)
        vm.prank(user);
        simpleStorage.withdraw(2 ether);
    }

    /// @notice withdraw 함수가 Withdrawn 이벤트를 발생시키는지 확인합니다
    function test_Withdraw_EmitsEvent() public {
        // Arrange: 먼저 2 ETH 입금
        vm.prank(user);
        simpleStorage.deposit{value: 2 ether}();

        // 다음 호출에서 Withdrawn 이벤트 예상
        vm.expectEmit(true, false, false, true);
        emit SimpleStorage.Withdrawn(user, 1 ether);

        // Act: 1 ETH 출금
        vm.prank(user);
        simpleStorage.withdraw(1 ether);
    }

    // ============================================================
    // Fuzz 테스트
    // ============================================================

    /// @notice 임의의 금액으로 입금 테스트 (Fuzz Testing)
    /// @dev Foundry가 자동으로 다양한 amount 값을 생성하여 테스트합니다
    /// @param amount 입금할 금액 (Foundry가 자동 생성)
    function testFuzz_Deposit(uint256 amount) public {
        // vm.assume: 특정 조건을 만족하는 입력만 테스트
        // amount가 0보다 크고, user의 잔액(10 ETH) 이하인 경우만 테스트
        vm.assume(amount > 0 && amount <= 10 ether);

        // Arrange: user가 호출하도록 설정
        vm.prank(user);

        // Act: amount만큼 입금
        simpleStorage.deposit{value: amount}();

        // Assert: 잔액이 amount와 같은지 확인
        assertEq(
            simpleStorage.getBalance(user),
            amount,
            "Balance should equal deposited amount"
        );
    }
}
