#[starknet::interface]
trait IBadMarket<TContractState> {
    fn incense_sold(self: @TContractState) -> felt252;
    fn coin_balance(self: @TContractState, owner: starknet::ContractAddress) -> felt252;
    fn claim_coin(ref self: TContractState);
    fn buy_incense(ref self: TContractState, amount: felt252);
}

#[starknet::contract]
mod BadMarket {
    
    use starknet::{ ContractAddress, get_caller_address };
    use starknet::storage::Map;

    const COST_OF_INCENSE: felt252 = 0x1777;

    #[storage]
    struct Storage {
        coin_balances: Map<ContractAddress, felt252>,
        incense_sold: felt252
    }

    #[abi(embed_v0)]
    impl BadMarketImpl of super::IBadMarket<ContractState> {
        fn incense_sold(self: @ContractState) -> felt252 {
            self.incense_sold.read()
        }

        fn coin_balance(self: @ContractState, owner: ContractAddress) -> felt252 {
            self.coin_balances.read(owner)
        }

        // Claim a free coin!
        fn claim_coin(ref self: ContractState) {
            let caller = get_caller_address();
            let balance = self.coin_balances.read(caller);

            self.coin_balances.write(caller, balance + 1);
        }

        fn buy_incense(ref self: ContractState, amount: felt252) {
            let caller = get_caller_address();
            let balance = self.coin_balances.read(caller);

            let total_cost = amount * COST_OF_INCENSE;
            assert(balance == total_cost, 'BAD_COIN_BALANCE');

            self.coin_balances.write(caller, 0);

            self.incense_sold.write(
                self.incense_sold.read() + amount
            );
        }
    }

}