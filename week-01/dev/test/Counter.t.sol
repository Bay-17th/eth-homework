// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import "../src/Counter.sol";

/// @title CounterTest - Week 1 테스트
/// @notice 이 테스트들이 모두 통과하도록 Counter.sol의 TODO를 구현하세요
/// @dev Foundry의 기본 테스트 패턴을 학습합니다
contract CounterTest is Test {
    // ============================================================
    // 테스트 상태 변수
    // ============================================================

    /// @notice 테스트할 Counter 컨트랙트 인스턴스
    Counter public counter;

    // ============================================================
    // setUp 함수
    // ============================================================

    /// @notice 각 테스트 전에 실행되는 설정 함수
    /// @dev 매 테스트마다 새로운 Counter 인스턴스가 생성됩니다 (테스트 격리)
    function setUp() public {
        // 새로운 Counter 컨트랙트 배포
        counter = new Counter();
    }

    // ============================================================
    // 테스트 함수들
    // ============================================================

    /// @notice 초기 count 값이 0인지 확인합니다
    /// @dev 상태 변수의 기본값 테스트
    function test_InitialCount_IsZero() public view {
        // Arrange: setUp에서 이미 counter가 생성됨

        // Act: count 값 조회
        uint256 currentCount = counter.count();

        // Assert: 초기값이 0인지 확인
        assertEq(currentCount, 0, "Initial count should be 0");
    }

    /// @notice increment 함수가 count를 1 증가시키는지 확인합니다
    /// @dev 기본 상태 변경 테스트
    function test_Increment_IncreasesCount() public {
        // Arrange: 초기 상태 (count = 0)

        // Act: increment 호출
        counter.increment();

        // Assert: count가 1이 되었는지 확인
        assertEq(counter.count(), 1, "Count should be 1 after increment");
    }

    /// @notice decrement 함수가 count를 1 감소시키는지 확인합니다
    /// @dev 두 번 증가 후 한 번 감소하여 count = 1 확인
    function test_Decrement_DecreasesCount() public {
        // Arrange: count를 2로 만듦
        counter.increment();
        counter.increment();

        // Act: decrement 호출
        counter.decrement();

        // Assert: count가 1이 되었는지 확인
        assertEq(counter.count(), 1, "Count should be 1 after two increments and one decrement");
    }

    /// @notice count가 0일 때 decrement를 호출하면 revert되는지 확인합니다
    /// @dev vm.expectRevert를 사용한 예외 테스트
    function test_RevertWhen_DecrementBelowZero() public {
        // Arrange: count = 0 (초기 상태)

        // Assert: 다음 호출이 revert될 것을 예상
        vm.expectRevert("Count cannot go below zero");

        // Act: decrement 호출 (0에서 감소 시도)
        counter.decrement();
    }

    /// @notice reset 함수가 count를 0으로 초기화하는지 확인합니다
    /// @dev 증가 후 reset하여 0으로 돌아가는지 확인
    function test_Reset_SetsCountToZero() public {
        // Arrange: count를 3으로 만듦
        counter.increment();
        counter.increment();
        counter.increment();

        // Act: reset 호출
        counter.reset();

        // Assert: count가 0이 되었는지 확인
        assertEq(counter.count(), 0, "Count should be 0 after reset");
    }
}
