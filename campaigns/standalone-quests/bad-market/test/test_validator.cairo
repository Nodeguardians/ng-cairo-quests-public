use array::ArrayTrait;
use option::OptionTrait;
use result::ResultTrait;
use traits::TryInto;

use starknet::ContractAddress;
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::deploy_syscall;
use starknet::Felt252TryIntoContractAddress;
use starknet::testing;

use bad_market::contracts::BadMarket;
use bad_market::utils::Validator;
use bad_market::interfaces::{
    IBadMarketDispatcher,
    IBadMarketDispatcherTrait
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

const ALICE: felt252 = 'AL1CE_ADDRE55';
const INCENSE_AMOUNT: felt252 
    = 0x7DC8AEE663208553BD58DB38B920C5BE1D3C37BE330E1B308A6B7ADD5A38570;

fn deploy_validator() -> IValidatorDispatcher {
    let validator_hash = Validator::TEST_CLASS_HASH.try_into().unwrap();

    let mut calldata = ArrayTrait::new();
    calldata.append(BadMarket::TEST_CLASS_HASH);

    let (validator_address, _) = deploy_syscall(
        validator_hash,
        0,
        calldata.span(),
        false
    ).unwrap();

    IValidatorDispatcher { contract_address: validator_address }
}

#[test]
#[available_gas(10000000)]
fn test_validate() {

    // 1. Deploy Validator
    let validator = deploy_validator();

    // 2. Deploy Market
    let alice_address = ALICE.try_into().unwrap();
    testing::set_contract_address(alice_address);
    validator.deploy(1);

    let market = IBadMarketDispatcher {
        contract_address: validator.deployments(alice_address, 1)
    };

    // 3. Market initially fails test
    assert(!validator.test(alice_address, 1), 'Test should fail');

    // 4. Execute solution
    market.claim_coin();
    market.buy_incense(INCENSE_AMOUNT);

    // 5. Market passes test
    assert(validator.test(alice_address, 1), 'Test should pass');
}