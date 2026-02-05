// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title VaultSecure (안전한 버전)
/// @author Bay-17th Ethereum Study
/// @notice 이 컨트랙트를 CEI 패턴 또는 ReentrancyGuard로 구현하세요
/// @dev 테스트를 통과하도록 아래 함수들을 구현하세요
///
/// ============================================
/// 구현 과제: 재진입 공격에 안전한 Vault 만들기
/// ============================================
///
/// 이 컨트랙트는 여러분이 직접 구현해야 합니다.
/// Vault.sol의 취약점을 이해하고, 안전한 버전을 작성하세요.
///
/// ============================================
/// 선택 1: CEI (Checks-Effects-Interactions) 패턴
/// ============================================
///
/// 순서만 바꾸면 됩니다:
/// 1. Checks: 조건 검증 (require, if)
/// 2. Effects: 상태 변경 (balances 업데이트)
/// 3. Interactions: 외부 호출 (call, transfer)
///
/// 예시:
/// ```solidity
/// function withdraw(uint256 amount) public {
///     // Checks
///     require(balances[msg.sender] >= amount, "Insufficient balance");
///
///     // Effects (상태 먼저 변경!)
///     balances[msg.sender] -= amount;
///
///     // Interactions (외부 호출은 마지막!)
///     (bool success, ) = msg.sender.call{value: amount}("");
///     require(success, "Transfer failed");
/// }
/// ```
///
/// ============================================
/// 선택 2: OpenZeppelin ReentrancyGuard
/// ============================================
///
/// OpenZeppelin의 검증된 라이브러리를 사용합니다:
///
/// ```solidity
/// import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
///
/// contract VaultSecure is ReentrancyGuard {
///     function withdraw(uint256 amount) public nonReentrant {
///         // 로직...
///     }
/// }
/// ```
///
/// nonReentrant modifier가 재진입을 막아줍니다.
///
/// ============================================
/// 어떤 방법을 선택할까?
/// ============================================
///
/// CEI 패턴:
/// - 장점: 가스 효율적, 외부 의존성 없음
/// - 단점: 개발자가 순서를 직접 관리해야 함
///
/// ReentrancyGuard:
/// - 장점: 실수 방지, 명시적, 검증된 코드
/// - 단점: 약간의 가스 오버헤드 (~2,500 gas)
///
/// 권장: 학습 목적으로 CEI 먼저 이해하고, 프로덕션에서는 둘 다 사용

// ============================================
// OpenZeppelin 사용 시 주석 해제
// ============================================
// import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/// @dev ReentrancyGuard 사용 시: contract VaultSecure is ReentrancyGuard
contract VaultSecure {
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
    ///
    /// TODO: deposit() 함수를 구현하세요
    /// - msg.value를 balances[msg.sender]에 추가
    /// - Deposited 이벤트 발생
    ///
    /// 힌트: Vault.sol의 deposit()과 동일하게 구현하면 됩니다
    function deposit() public payable {
        // TODO: 구현하세요
    }

    /// @notice 예치한 ETH를 출금합니다
    /// @param amount 출금할 ETH 양 (wei 단위)
    ///
    /// TODO: withdraw(uint256 amount) 함수를 구현하세요
    /// - 재진입 공격에 안전하게 구현
    /// - CEI 패턴 또는 ReentrancyGuard 사용
    ///
    /// 필수 요소:
    /// 1. 잔액 확인 (require)
    /// 2. 잔액 차감 (balances 업데이트)
    /// 3. ETH 전송 (call)
    /// 4. Withdrawn 이벤트 발생
    ///
    /// CEI 패턴 사용 시 순서: Checks -> Effects -> Interactions
    /// ReentrancyGuard 사용 시: nonReentrant modifier 추가
    function withdraw(uint256 amount) public {
        // TODO: 구현하세요
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
