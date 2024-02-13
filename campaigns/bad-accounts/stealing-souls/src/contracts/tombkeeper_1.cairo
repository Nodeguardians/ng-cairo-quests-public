use super::commons::ITombkeeper;

#[starknet::contract(account)]
mod Tombkeeper1 {

    use array::{ ArrayTrait };
    use starknet::{ account::Call, ContractAddress };

    use src::contracts::soul_token::{ 
        IERC20Dispatcher,
        IERC20DispatcherTrait
    };

    const SOUL_FEE: u256 = 100000000000000000; // 0.1 SOUL

    #[storage]
    struct Storage {
        soul_token: IERC20Dispatcher, 
        soul_vault: ContractAddress
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
            validate_calls(calls, soul_token.contract_address);

            starknet::VALIDATED
        }

        fn __execute__(ref self: ContractState, calls: Array<Call>) -> Array<Span<felt252>> {

            // 1. Execute Calls
            let mut results = ArrayTrait::new();
            execute_calls(calls, ref results);

            // 2. Pay Fee
            let soul_token = self.soul_token.read();
            let soul_vault = self.soul_vault.read(); 
            assert(
                soul_token.transfer(soul_vault, SOUL_FEE),
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
    ) {
        match calls.pop_front() {
            Option::Some(call) => {
                // Trying to steal some soul? Nice try...
                assert(call.to != blacklisted, 'CANNOT_CALL_SOUL_TOKEN');
            },
            Option::None(_) => {
                return ();
            }
        }

        validate_calls(calls, blacklisted)
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