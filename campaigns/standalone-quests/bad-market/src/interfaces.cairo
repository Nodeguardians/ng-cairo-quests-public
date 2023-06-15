#[abi]
trait IBadMarket {

    #[view]
    fn get_incense_sold() -> felt252;

    #[external]
    fn claim_coin();

    #[external]
    fn buy_incense(amount: felt252);

}