use array::ArrayTrait;
use option::OptionTrait;
use result::ResultTrait;
use traits::TryInto;

use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::deploy_syscall;
use starknet::Felt252TryIntoContractAddress;
use starknet::testing;

use bad_market::contracts::BadMarket;
use bad_market::interfaces::{
    IBadMarketDispatcher,
    IBadMarketDispatcherTrait
};

/// @notice INCENSE_AMOUNT = 1 / 0x1777 (mod P)
const INCENSE_AMOUNT: felt252 = 0x7DC8AEE663208553BD58DB38B920C5BE1D3C37BE330E1B308A6B7ADD5A38570;

fn deploy_market() -> IBadMarketDispatcher {
    let market_hash = BadMarket::TEST_CLASS_HASH.try_into().unwrap();

    let (market_address, _) = deploy_syscall(
        market_hash,
        0,
        ArrayTrait::new().span(),
        false
    ).unwrap();

    IBadMarketDispatcher { contract_address: market_address }
}

#[test]
#[available_gas(1000000)]
#[should_panic]
fn test_insufficient_coin() {
    let market = deploy_market();

    market.claim_coin();
    market.buy_incense(100000000000);
    
}

#[test]
#[available_gas(1000000)]
fn test_unchecked_overflow() {
    let market = deploy_market();

    market.claim_coin();
    market.buy_incense(INCENSE_AMOUNT);

}