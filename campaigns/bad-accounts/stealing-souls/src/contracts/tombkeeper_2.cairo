use super::commons::ITombkeeper;

#[starknet::contract(account)]
mod Tombkeeper2 {

    use array::ArrayTrait;
    use starknet::{ account::Call, ContractAddress, get_caller_address };
    use zeroable::Zeroable;

    use src::contracts::soul_token::{ 
        IERC20Dispatcher,
        IERC20DispatcherTrait
    };

    const SOUL_FEE: u256 = 100000000000000000; // 0.1 SOUL
    const IMPOSSIBLE_SOUL_FEE: u256 = 100000000000000000000000000000000; // 10^13 SOUL

    #[storage]
    struct Storage {
        soul_token: IERC20Dispatcher, 
        soul_vault: ContractAddress,
        total_fee: u256
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, 
        soul_token: IERC20Dispatcher,
        soul_vault: ContractAddress
    ) {
        self.soul_token.write(soul_token);
        self.soul_vault.write(soul_vault);
    }

    #[abi(embed_v0)]
    impl TombkeeperImpl of super::ITombkeeper<ContractState> {

        fn __validate__(ref self: ContractState, calls: Array<Call>) -> felt252 {
            let soul_token = self.soul_token.read();
            let total_fee = validate_calls(calls, soul_token.contract_address);
            
            self.total_fee.write(total_fee);

            starknet::VALIDATED
        }

        fn __execute__(ref self: ContractState, calls: Array<Call>) -> Array<Span<felt252>>{
            assert(get_caller_address().is_zero(), 'INVALID_CALLER');

            // 1. Execute Calls
            let mut results = ArrayTrait::new();
            execute_calls(calls, ref results);

            // 2. Pay Fee
            let soul_token = self.soul_token.read();
            let soul_vault = self.soul_vault.read();
            let soul_fee = self.total_fee.read();
            assert(
                soul_token.transfer(soul_vault, soul_fee),
                'SOUL_NOT_PAID'
            );

            results
        }

        fn soul_token(self: @ContractState) -> ContractAddress {
            self.soul_token.read().contract_address
        }

        fn soul_vault(self: @ContractState) -> ContractAddress {
            self.soul_vault.read()
        }

    }

    fn validate_calls(
        mut calls: Array<Call>, 
        blacklisted: ContractAddress
    ) -> u256 {
        match calls.pop_front() {
            Option::Some(call) => {
                let total_fee = validate_calls(calls, blacklisted);
                if call.to == blacklisted {
                    // Trying to steal some soul? Nice try...
                    total_fee + IMPOSSIBLE_SOUL_FEE 
                } else {
                    total_fee + SOUL_FEE
                }
            },
            Option::None(_) => 0
        }
    }

    fn execute_calls(mut calls: Array<Call>, ref results: Array<Span<felt252>>) {
        match calls.pop_front() {
            Option::Some(call) => {
                let Call { to, selector, calldata } = call;
                let call_result = starknet::call_contract_syscall(
                    to, selector, calldata
                ).unwrap();

                results.append(call_result)
            },
            Option::None(_) => {
                return ();
            }
        }

        execute_calls(calls, ref results);
    }
}