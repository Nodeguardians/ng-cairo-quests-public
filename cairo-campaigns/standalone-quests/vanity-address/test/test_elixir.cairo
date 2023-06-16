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
use elixir::interfaces::{
    IElixirDispatcher,
    IElixirDispatcherTrait
};

const ACIDIC: felt252 = 0x0AC1D1C0000111122223333444455556666777788889999AAAABBBBCC;
const NON_ACIDIC: felt252 = 0x0000111122223333444455556666777788889999AAAABBBBCCCCDDEEF;

fn deploy_elixir() -> IElixirDispatcher {
    let elixir_hash = Elixir::TEST_CLASS_HASH.try_into().unwrap();

    let (elixir_address, _) = deploy_syscall(
        elixir_hash,
        0,
        ArrayTrait::new().span(),
        false
    ).unwrap();

    IElixirDispatcher { contract_address: elixir_address }
}

#[test]
#[available_gas(1000000)]
fn test_acidic_address() {

    let elixir = deploy_elixir();
    testing::set_contract_address(ACIDIC.try_into().unwrap());
    elixir.try_to_brew();

    assert(elixir.brewed(), 'Elixir should be brewed');
}

#[test]
#[available_gas(1000000)]
#[should_panic()] // TODO: Add expected panic message - 'NOT_ACIDIC'
fn test_non_acidic_address() {

    let elixir = deploy_elixir();
    testing::set_contract_address(NON_ACIDIC.try_into().unwrap());
    elixir.try_to_brew();

}