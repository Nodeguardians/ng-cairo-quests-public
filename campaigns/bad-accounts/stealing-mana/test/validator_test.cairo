use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;
use starknet::testing;
use traits::TryInto;
use src::contracts::mana_hoarder::{
    ManaHoarder,
    IManaHoarderDispatcher,
    IManaHoarderDispatcherTrait
};
use src::utils::validator::IValidatorDispatcherTrait;

use src::contracts::erc20::{
    IERC20Dispatcher, 
    IERC20DispatcherTrait 
};

use src::solution::attacker::{
    IAttackerDispatcherTrait
};

use test::utils::transaction::send_mock_call;
use test::utils::deployment::{
    deploy_attacker,
    deploy_validator
};

const ALICE: felt252 = 'AL1CE_ADDRE55';
const ATTACK_SELECTOR: felt252 = 0x2d1af4265f4530c75b41282ed3b71617d3d435e96fe13b08848482173692f4f;

#[test]
#[available_gas(1000000000000)]
fn test_validator() {
    let validator = deploy_validator();

    let alice_address = ALICE.try_into().unwrap();
    testing::set_contract_address(alice_address);
    validator.deploy(1);

    assert(!validator.test(alice_address, 1), 'Test should fail');

    let hoarder = IManaHoarderDispatcher {
        contract_address: validator.deployments(alice_address, 1)
    };
    init_attack(hoarder);

    assert(validator.test(alice_address, 1), 'Test should pass');
}

fn init_attack(target: IManaHoarderDispatcher) {

    // 1. Set mana source and approve expenditure
    let alice_address = ALICE.try_into().unwrap();
    testing::set_contract_address(alice_address);

    let mana_token = IERC20Dispatcher {
        contract_address: target.get_mana_token()
    };

    let allowance = 2 * ManaHoarder::MANA_FEE;
    testing::set_contract_address(alice_address);
    mana_token.approve(target.contract_address, allowance);
    target.set_mana_source(alice_address);

    // 2. Initiate attack
    let attacker = deploy_attacker();
    send_mock_call(
        from: target.contract_address,
        to: attacker.contract_address,
        selector: ATTACK_SELECTOR,
        calldata: ArrayTrait::new()
    );

}