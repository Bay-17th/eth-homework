// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title Counter - Week 1 과제
/// @notice 간단한 카운터 컨트랙트입니다. TODO 부분을 구현하세요.
/// @dev 이 컨트랙트는 Solidity 기초를 배우기 위한 연습용입니다.
contract Counter {
    // ============================================================
    // 상태 변수 (State Variables)
    // ============================================================

    /// @notice 현재 카운트 값을 저장합니다
    /// @dev public으로 선언하면 자동으로 getter 함수가 생성됩니다
    uint256 public count;

    // ============================================================
    // 읽기 함수 (View Functions)
    // ============================================================

    /// @notice 현재 카운트 값을 반환합니다
    /// @return 현재 count 값
    function getCount() public view returns (uint256) {
        return count;
    }

    // ============================================================
    // 쓰기 함수 (State-Changing Functions)
    // ============================================================

    /// @notice 카운트를 1 증가시킵니다
    /// @dev count 값을 1만큼 증가시키는 로직을 구현하세요
    function increment() public {
        // TODO: count를 1 증가시키세요
        // 힌트: count += 1; 또는 count = count + 1; 또는 count++;
        count += 1;
    }

    /// @notice 카운트를 1 감소시킵니다
    /// @dev count가 0일 때 감소시키면 언더플로우가 발생합니다
    function decrement() public {
        // TODO: count를 1 감소시키세요. 단, count가 0이면 revert해야 합니다.
        // 힌트: require(조건, "에러 메시지"); 를 사용하세요
        // 힌트: require(count > 0, "Count cannot go below zero");
        require(count > 0, "Count cannot go below zero");
        count -= 1;
    }

    /// @notice 카운트를 0으로 초기화합니다
    /// @dev count 값을 0으로 설정하는 로직을 구현하세요
    function reset() public {
        // TODO: count를 0으로 초기화하세요
        // 힌트: count = 0;
        count = 0;
    }
}
