use array::ArrayTrait;
use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;
use starknet::testing;
use traits::TryInto;

use src::contracts::gate::{ IGateDispatcher, IGateDispatcherTrait };
use src::utils::validator::{ IValidatorDispatcher, IValidatorDispatcherTrait };

use test::utils::deployment::deploy_validator;
use test::utils::signer;
use test::utils::transaction::send_mock_call;

const ALICE: felt252 = 'AL1CE_ADDRE55';
const PRIVATE_KEY: felt252 = 'PR1V4T3_K37';
const OPEN_SELECTOR: felt252 = 0x1f30275ab70dd1890c0789c4570632b6f0b0284d11c2d9e587d0368f7027018;
const TEST_HASH: felt252 = 0x000DEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEEDEADC0FFEE;

#[test]
#[available_gas(100000000000)]
fn test_validate() {
    let validator = deploy_validator();

    let alice_address = ALICE.try_into().unwrap();
    testing::set_contract_address(alice_address);
    validator.deploy(1);

    assert(!validator.test(alice_address, 1), 'Test should fail');

    let gate = IGateDispatcher {
        contract_address: validator.deployments(alice_address, 1)
    };

    init_attack(gate);

    assert(validator.test(alice_address, 1), 'Test should pass');
}

fn init_attack(gate: IGateDispatcher) {
    let (r, s) = signer::sign(PRIVATE_KEY, TEST_HASH);
    let (pub_x, _) = signer::compute_public_key(PRIVATE_KEY);

    let mut signature = ArrayTrait::new();
    signature.append(pub_x);
    signature.append(r);
    signature.append(s);
    signature.append(pub_x);
    signature.append(r);
    signature.append(ec::StarkCurve::ORDER - s);

    send_mock_call(
        from: gate.gatekeeper(),
        to: gate.contract_address,
        selector: OPEN_SELECTOR,
        calldata: ArrayTrait::new(),
        dummy_hash: TEST_HASH,
        signature: signature
    );

}