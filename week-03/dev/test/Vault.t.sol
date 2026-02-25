// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { VaultSecure } from "../src/VaultSecure.sol";

/// @title VaultTest
/// @author Bay-17th Ethereum Study
/// @notice VaultSecure 컨트랙트의 TDD 테스트 스위트
/// @dev 이 테스트들을 모두 통과하도록 VaultSecure를 구현하세요
///
/// ============================================
/// TDD (Test-Driven Development) 접근법
/// ============================================
///
/// 1. 테스트를 먼저 읽고 예상 동작을 파악하세요
/// 2. VaultSecure.sol을 구현하세요
/// 3. 모든 테스트가 통과하는지 확인하세요
///
/// 테스트 실행:
/// forge test --match-path week-03/dev/test/Vault.t.sol -vv
///
/// 특정 테스트만 실행:
/// forge test --match-test test_Deposit -vv

/// @dev 재진입 공격을 시뮬레이션하는 공격자 컨트랙트
/// 이 컨트랙트는 VaultSecure가 재진입에 안전한지 테스트합니다
contract Attacker {
    VaultSecure public vault;
    uint256 public attackCount;
    uint256 public attackAmount;

    /// @dev 공격자 컨트랙트 생성자
    /// @param _vault 공격 대상 VaultSecure 주소
    constructor(address _vault) {
        vault = VaultSecure(_vault);
    }

    /// @notice 재진입 공격을 시작합니다
    /// @dev msg.value만큼 입금 후 출금을 시도하여 재진입 공격
    function attack() external payable {
        attackAmount = msg.value;
        attackCount = 0;

        // 1. 정상적으로 입금
        vault.deposit{ value: msg.value }();

        // 2. 출금 시도 - 이 때 receive()가 트리거됨
        vault.withdraw(msg.value);
    }

    /// @dev ETH를 받을 때 자동으로 호출되는 함수
    /// 재진입 공격의 핵심: 출금받을 때 다시 출금 시도
    receive() external payable {
        // 최대 5번까지 재진입 시도 (무한 루프 방지)
        // VaultSecure가 안전하다면 두 번째 withdraw()는 실패해야 함
        if (attackCount < 5 && address(vault).balance >= attackAmount) {
            attackCount++;
            console.log("Reentrancy attempt:", attackCount);
            vault.withdraw(attackAmount);
        }
    }

    /// @notice 공격자가 탈취한 ETH 확인
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

/// @title VaultSecureTest
/// @notice VaultSecure 컨트랙트의 모든 기능을 테스트합니다
contract VaultSecureTest is Test {
    // ============================================
    // 상태 변수
    // ============================================

    VaultSecure public vault;
    Attacker public attacker;

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    uint256 public constant INITIAL_BALANCE = 10 ether;

    // ============================================
    // 테스트 이벤트 (이벤트 발생 검증용)
    // ============================================

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    // ============================================
    // Setup
    // ============================================

    /// @dev 각 테스트 전에 실행되는 설정 함수
    function setUp() public {
        // VaultSecure 배포
        vault = new VaultSecure();

        // Attacker 배포 (재진입 테스트용)
        attacker = new Attacker(address(vault));

        // 테스트 계정에 ETH 지급
        vm.deal(alice, INITIAL_BALANCE);
        vm.deal(bob, INITIAL_BALANCE);
        vm.deal(address(attacker), INITIAL_BALANCE);
    }

    // ============================================
    // Deposit 테스트
    // ============================================

    /// @notice 입금 시 사용자 잔액이 증가하는지 테스트
    /// @dev 예상: 1 ETH 입금 후 balances[alice] == 1 ether
    function test_Deposit_IncreasesUserBalance() public {
        // Arrange (준비)
        // Alice가 1 ETH를 입금할 예정

        // Act (실행)
        vm.prank(alice);
        vault.deposit{ value: 1 ether }();

        // Assert (검증)
        // Alice의 balances가 1 ether인지 확인
        assertEq(vault.balances(alice), 1 ether, "User balance should increase after deposit");
    }

    /// @notice 입금 시 컨트랙트 잔액이 증가하는지 테스트
    /// @dev 예상: 1 ETH 입금 후 address(vault).balance == 1 ether
    function test_Deposit_IncreasesContractBalance() public {
        // Arrange
        uint256 initialVaultBalance = address(vault).balance;

        // Act
        vm.prank(alice);
        vault.deposit{ value: 1 ether }();

        // Assert
        assertEq(
            address(vault).balance,
            initialVaultBalance + 1 ether,
            "Contract balance should increase after deposit"
        );
    }

    /// @notice 입금 시 Deposited 이벤트가 발생하는지 테스트
    /// @dev 예상: Deposited(alice, 1 ether) 이벤트 발생
    function test_Deposit_EmitsDepositedEvent() public {
        // Arrange
        // 이벤트 발생 예상 설정
        vm.expectEmit(true, false, false, true);
        emit Deposited(alice, 1 ether);

        // Act
        vm.prank(alice);
        vault.deposit{ value: 1 ether }();

        // Assert는 expectEmit이 자동으로 처리
    }

    /// @notice 여러 번 입금 시 잔액이 누적되는지 테스트
    /// @dev 예상: 1 ETH + 2 ETH 입금 후 balances[alice] == 3 ether
    function test_Deposit_AccumulatesBalance() public {
        // Arrange & Act
        vm.startPrank(alice);
        vault.deposit{ value: 1 ether }();
        vault.deposit{ value: 2 ether }();
        vm.stopPrank();

        // Assert
        assertEq(vault.balances(alice), 3 ether, "Multiple deposits should accumulate");
    }

    // ============================================
    // Withdraw 테스트
    // ============================================

    /// @notice 출금 시 사용자 잔액이 감소하는지 테스트
    /// @dev 예상: 3 ETH 입금 후 1 ETH 출금하면 balances[alice] == 2 ether
    function test_Withdraw_DecreasesUserBalance() public {
        // Arrange
        vm.startPrank(alice);
        vault.deposit{ value: 3 ether }();
        uint256 balanceBefore = vault.balances(alice);

        // Act
        vault.withdraw(1 ether);
        vm.stopPrank();

        // Assert
        assertEq(
            vault.balances(alice),
            balanceBefore - 1 ether,
            "User balance should decrease after withdraw"
        );
    }

    /// @notice 출금 시 사용자에게 ETH가 전송되는지 테스트
    /// @dev 예상: 1 ETH 출금 후 Alice의 실제 ETH 잔액이 1 ETH 증가
    function test_Withdraw_TransfersEtherToUser() public {
        // Arrange
        vm.startPrank(alice);
        vault.deposit{ value: 3 ether }();
        uint256 aliceBalanceBefore = address(alice).balance;

        // Act
        vault.withdraw(1 ether);
        vm.stopPrank();

        // Assert
        assertEq(
            address(alice).balance,
            aliceBalanceBefore + 1 ether,
            "ETH should be transferred to user after withdraw"
        );
    }

    /// @notice 출금 시 Withdrawn 이벤트가 발생하는지 테스트
    /// @dev 예상: Withdrawn(alice, 1 ether) 이벤트 발생
    function test_Withdraw_EmitsWithdrawnEvent() public {
        // Arrange
        vm.prank(alice);
        vault.deposit{ value: 3 ether }();

        // 이벤트 발생 예상 설정
        vm.expectEmit(true, false, false, true);
        emit Withdrawn(alice, 1 ether);

        // Act
        vm.prank(alice);
        vault.withdraw(1 ether);
    }

    /// @notice 잔액보다 많이 출금하려고 하면 revert되는지 테스트
    /// @dev 예상: 1 ETH 입금 후 2 ETH 출금 시도하면 "Insufficient balance" revert
    function test_RevertWhen_WithdrawExceedsBalance() public {
        // Arrange
        vm.prank(alice);
        vault.deposit{ value: 1 ether }();

        // Act & Assert
        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(2 ether);
    }

    /// @notice 잔액이 없는 계정이 출금하려고 하면 revert되는지 테스트
    /// @dev 예상: 입금 없이 출금 시도하면 "Insufficient balance" revert
    function test_RevertWhen_WithdrawWithZeroBalance() public {
        // Act & Assert
        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(1 ether);
    }

    // ============================================
    // 재진입 공격 테스트 (가장 중요!)
    // ============================================

    /// @notice 재진입 공격이 Vault를 drain하지 못하는지 테스트
    /// @dev 이 테스트가 통과하면 VaultSecure는 재진입에 안전합니다!
    ///
    /// 시나리오:
    /// 1. Bob이 5 ETH 입금 (선량한 사용자)
    /// 2. Attacker가 1 ETH 입금 후 재진입 공격 시도
    /// 3. VaultSecure가 안전하다면:
    ///    - Attacker는 자신이 입금한 1 ETH만 출금 가능
    ///    - Bob의 5 ETH는 안전하게 보존됨
    ///    - Vault에는 여전히 5 ETH가 남아있음
    function test_ReentrancyAttack_CannotDrainVault() public {
        // ============================================
        // Arrange (준비)
        // ============================================

        // Bob이 먼저 5 ETH 입금 (선량한 사용자)
        vm.prank(bob);
        vault.deposit{ value: 5 ether }();

        console.log("=== Before Attack ===");
        console.log("Vault balance:", address(vault).balance);
        console.log("Attacker balance:", address(attacker).balance);

        uint256 vaultBalanceBefore = address(vault).balance;
        uint256 attackerBalanceBefore = address(attacker).balance;

        // ============================================
        // Act (실행)
        // ============================================

        // Attacker가 1 ETH로 재진입 공격 시도
        // attack() 내부에서:
        // 1. 1 ETH 입금
        // 2. 1 ETH 출금 시도
        // 3. receive()에서 추가 출금 시도 (재진입)
        attacker.attack{ value: 1 ether }();

        console.log("=== After Attack ===");
        console.log("Vault balance:", address(vault).balance);
        console.log("Attacker balance:", address(attacker).balance);
        console.log("Reentrancy attempts:", attacker.attackCount());

        // ============================================
        // Assert (검증)
        // ============================================

        // Vault에는 Bob의 5 ETH가 그대로 있어야 함
        // (Attacker가 입금한 1 ETH는 정상 출금되어 빠짐)
        assertEq(
            address(vault).balance,
            5 ether,
            "Vault should still have Bob's 5 ETH - reentrancy should not drain funds!"
        );

        // Attacker는 자신이 입금한 1 ETH만 돌려받음
        // 10 ETH (초기) - 1 ETH (입금) + 1 ETH (정상 출금) = 10 ETH
        assertEq(
            address(attacker).balance,
            attackerBalanceBefore,
            "Attacker should only get back their deposited amount"
        );

        // 재진입 시도는 실패해야 함 (attackCount가 0이거나 revert됨)
        // CEI 패턴: 두 번째 withdraw에서 잔액이 이미 0이므로 revert
        // ReentrancyGuard: nonReentrant에서 revert
        console.log("Reentrancy was blocked! Attack count:", attacker.attackCount());
    }

    /// @notice 재진입 공격 시 Attacker가 자신의 입금액만 받는지 테스트
    /// @dev 정상 동작 확인: 입금한 만큼만 출금 가능
    function test_ReentrancyAttack_AttackerGetsOnlyOwnDeposit() public {
        // Arrange
        vm.prank(bob);
        vault.deposit{ value: 5 ether }();

        // Act
        attacker.attack{ value: 2 ether }();

        // Assert
        // Attacker의 vault 잔액은 0이어야 함 (정상 출금 완료)
        assertEq(
            vault.balances(address(attacker)),
            0,
            "Attacker balance in vault should be 0 after withdraw"
        );

        // Bob의 vault 잔액은 그대로 5 ETH
        assertEq(vault.balances(bob), 5 ether, "Bob's balance should be intact");
    }

    // ============================================
    // getBalance 테스트
    // ============================================

    /// @notice getBalance()가 정확한 컨트랙트 잔액을 반환하는지 테스트
    function test_GetBalance_ReturnsContractBalance() public {
        // Arrange
        vm.prank(alice);
        vault.deposit{ value: 3 ether }();

        vm.prank(bob);
        vault.deposit{ value: 2 ether }();

        // Act
        uint256 balance = vault.getBalance();

        // Assert
        assertEq(balance, 5 ether, "getBalance should return total contract balance");
    }
}

/// @title VaultVulnerableTest
/// @notice 취약한 Vault 컨트랙트가 실제로 재진입에 취약한지 확인하는 테스트
/// @dev 이 테스트는 Vault(취약)와 VaultSecure(안전)의 차이를 보여줍니다
contract VaultVulnerableTest is Test {
    Vault public vulnerableVault;
    AttackerForVault public attackerVulnerable;

    address public bob = makeAddr("bob");

    function setUp() public {
        vulnerableVault = new Vault();
        attackerVulnerable = new AttackerForVault(address(vulnerableVault));

        vm.deal(bob, 10 ether);
        vm.deal(address(attackerVulnerable), 10 ether);
    }

    /// @notice 취약한 Vault가 실제로 drain되는지 테스트
    /// @dev 이 테스트는 재진입 공격의 위험성을 보여줍니다
    function test_VulnerableVault_CanBeDrained() public {
        // Arrange
        vm.prank(bob);
        vulnerableVault.deposit{ value: 5 ether }();

        console.log("=== Vulnerable Vault Before Attack ===");
        console.log("Vault balance:", address(vulnerableVault).balance);

        // Act - 공격!
        attackerVulnerable.attack{ value: 1 ether }();

        console.log("=== Vulnerable Vault After Attack ===");
        console.log("Vault balance:", address(vulnerableVault).balance);
        console.log("Attacker stolen:", address(attackerVulnerable).balance - 9 ether);

        // Assert
        // 취약한 Vault는 완전히 drain됨!
        assertEq(
            address(vulnerableVault).balance,
            0,
            "Vulnerable vault should be completely drained by reentrancy attack"
        );

        // 공격자가 Bob의 ETH까지 탈취
        assertGt(address(attackerVulnerable).balance, 10 ether, "Attacker should have stolen ETH");
    }
}

/// @dev 취약한 Vault를 공격하는 컨트랙트
contract AttackerForVault {
    Vault public vault;
    uint256 public attackCount;

    constructor(address _vault) {
        vault = Vault(_vault);
    }

    function attack() external payable {
        vault.deposit{ value: msg.value }();
        vault.withdraw(msg.value);
    }

    receive() external payable {
        if (attackCount < 10 && address(vault).balance >= 1 ether) {
            attackCount++;
            vault.withdraw(1 ether);
        }
    }
}
