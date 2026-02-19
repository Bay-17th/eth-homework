// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title SimpleStorage - Week 2 과제
/// @notice ETH를 입금하고 출금하는 간단한 저장소 컨트랙트입니다.
/// @dev mapping, event, payable 함수를 학습합니다.
contract SimpleStorage {
    // ============================================================
    // 상태 변수 (State Variables)
    // ============================================================

    /// @notice 각 주소별 잔액을 저장합니다
    /// @dev mapping은 key(address) => value(uint256) 형태의 저장소입니다
    mapping(address => uint256) public balances;

    // ============================================================
    // 이벤트 (Events)
    // ============================================================

    /// @notice 입금 시 발생하는 이벤트
    /// @param user 입금한 사용자 주소 (indexed로 검색 가능)
    /// @param amount 입금한 금액 (wei 단위)
    event Deposited(address indexed user, uint256 amount);

    /// @notice 출금 시 발생하는 이벤트
    /// @param user 출금한 사용자 주소 (indexed로 검색 가능)
    /// @param amount 출금한 금액 (wei 단위)
    event Withdrawn(address indexed user, uint256 amount);

    // ============================================================
    // 읽기 함수 (View Functions)
    // ============================================================

    /// @notice 특정 사용자의 잔액을 조회합니다
    /// @param user 조회할 사용자 주소
    /// @return 해당 사용자의 잔액 (wei 단위)
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }

    // ============================================================
    // 쓰기 함수 (State-Changing Functions)
    // ============================================================

    /// @notice ETH를 입금합니다
    /// @dev msg.value는 함수 호출 시 전송된 ETH 양입니다
    function deposit() public payable {
        // TODO: 입금 로직을 구현하세요
        // 1. balances[msg.sender]에 msg.value를 더합니다
        // 2. Deposited 이벤트를 발생시킵니다
        //
        // 힌트:
        // balances[msg.sender] += msg.value;
        // emit Deposited(msg.sender, msg.value);

        unchecked {
            balances[msg.sender] += msg.value;
        }

        emit Deposited(msg.sender, msg.value);
    }

    /// @notice ETH를 출금합니다
    /// @param amount 출금할 금액 (wei 단위)
    /// @dev 잔액이 충분한지 확인 후, ETH를 전송합니다
    function withdraw(uint256 amount) public {
        // TODO: 출금 로직을 구현하세요
        // 1. 사용자의 잔액이 amount 이상인지 확인합니다 (require 사용)
        // 2. balances[msg.sender]에서 amount를 뺍니다
        // 3. msg.sender에게 ETH를 전송합니다
        // 4. Withdrawn 이벤트를 발생시킵니다
        //
        // 힌트:
        // require(balances[msg.sender] >= amount, "Insufficient balance");
        // balances[msg.sender] -= amount;
        // payable(msg.sender).transfer(amount);
        // emit Withdrawn(msg.sender, amount);

        require(balances[msg.sender] >= amount, "Insufficient balance");

        unchecked {
            balances[msg.sender] -= amount;
        }

        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }
}
