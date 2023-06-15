use array::ArrayTrait;
use option::OptionTrait;
use result::ResultTrait;
use traits::TryInto;

use starknet::ContractAddress;
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::deploy_syscall;
use starknet::Felt252TryIntoContractAddress;
use starknet::testing;

use elixir::contracts::Elixir;
use elixir::utils::Validator;
use elixir::interfaces::{
    IElixirDispatcher,
    IElixirDispatcherTrait
};

// TODO: Move to global package
#[abi]
trait IValidator {
    #[view]
    fn deployments(user: ContractAddress, k: u8) -> ContractAddress;
    #[view]
    fn test(user: ContractAddress, k: u8) -> bool;
    #[view]
    fn contract_name(user: ContractAddress, k: u8) -> felt252;
    #[external]
    fn deploy(k: u8);
}

const ALICE: felt252 = 'AL1C3_ADDRE55';
const ACIDIC: felt252 = 0x0AC1D1C0000111122223333444455556666777788889999AAAABBBBCC;

fn deploy_validator() -> IValidatorDispatcher {
    let validator_hash = Validator::TEST_CLASS_HASH.try_into().unwrap();

    let mut calldata = ArrayTrait::new();
    calldata.append(Elixir::TEST_CLASS_HASH);

    let (validator_address, _) = deploy_syscall(
        validator_hash,
        0,
        calldata.span(),
        false
    ).unwrap();

    IValidatorDispatcher { contract_address: validator_address }
}

#[test]
#[available_gas(1000000)]
fn test_validate() {

    // 1. Deploy Validator
    let validator = deploy_validator();

    // 2. Deploy Elixir
    let alice_address = ALICE.try_into().unwrap();
    testing::set_contract_address(alice_address);
    validator.deploy(1);

    let elixir = IElixirDispatcher {
        contract_address: validator.deployments(alice_address, 1)
    };

    // 3. Elixir initially fails test
    assert(!validator.test(alice_address, 1), 'Test should fail');

    // 4. Execute solution
    testing::set_contract_address(ACIDIC.try_into().unwrap());
    elixir.try_to_brew();

    // 5. Elixir passes test
    assert(validator.test(alice_address, 1), 'Test should pass');
}