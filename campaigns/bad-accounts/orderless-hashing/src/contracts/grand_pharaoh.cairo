#[starknet::interface]
trait AccountContract<TContractState> {
    fn __validate_declare__(self: @TContractState, class_hash: felt252) -> felt252;
    fn __validate__(ref self: TContractState, calls: Array<starknet::account::Call>) -> felt252;
    fn __execute__(ref self: TContractState, calls: Array<starknet::account::Call>) -> Array<Span<felt252>>;
}

#[starknet::contract]
mod GrandPharaoh {
    use array::{ ArrayTrait, SpanTrait };
    use box::BoxTrait;
    use ecdsa::check_ecdsa_signature;
    use option::OptionTrait;
    use traits::Into;
    use zeroable::Zeroable;

    use starknet::account::Call;
    use starknet::get_tx_info;

    #[storage]
    struct Storage {
        pub_key: felt252
    }

    #[constructor]
    fn constructor(ref self: ContractState, pub_key: felt252) {
        self.pub_key.write(pub_key);
    }

    #[external(v0)]
    impl AccountImpl of super::AccountContract<ContractState> {

        fn __validate_declare__(self: @ContractState, class_hash: felt252) -> felt252 {
            0 // Declaration not supported
        }

        fn __validate__(ref self: ContractState, calls: Array<Call>) -> felt252 {
            let (r, s) = get_signature();
            
            let multicall_hash = get_multicall_hash(calls);

            let is_valid = check_ecdsa_signature(
                message_hash: multicall_hash.low.into() * multicall_hash.high.into(),
                public_key: self.pub_key.read(),
                signature_r: r,
                signature_s: s
            );

            assert(is_valid, 'INVALID_SIGNATURE');

            starknet::VALIDATED
        }

        fn __execute__(ref self: ContractState, calls: Array<Call>) -> Array<Span<felt252>> {
            assert(starknet::get_caller_address().is_zero(), 'INVALID_CALLER');

            let mut results = ArrayTrait::new();
            execute_calls(calls, ref results);

            results
        }
    }

    fn execute_calls(mut calls: Array<Call>, ref results: Array<Span<felt252>>) {
        match calls.pop_front() {
            Option::Some(call) => {
                let Call { to, selector, calldata } = call;
                let call_result = starknet::call_contract_syscall(
                    to, selector, calldata.span()
                );

                results.append(call_result.unwrap_syscall())
            },
            Option::None(_) => {
                return ();
            }
        }

        execute_calls(calls, ref results);
    }

    fn get_signature() -> (felt252, felt252) {
        let tx_info = get_tx_info().unbox();
        let raw_sig = tx_info.signature;

        assert(raw_sig.len() == 2, 'INVALID_SIGNATURE_LENGTH');

        (*raw_sig[0], *raw_sig[1])
    }
    
    fn get_multicall_hash(mut calls: Array<Call>) -> u256 {
        match calls.pop_front() {
            Option::Some(call) => {
                let next_hash = get_call_hash(call);
                next_hash ^ get_multicall_hash(calls)
            },
            Option::None(_) => 0
        }
    }

    fn get_call_hash(call: Call) -> u256 {
        let Call { to, selector, calldata } = call;

        let h1 = pedersen(to.into(), selector);
        let h2 = poseidon::poseidon_hash_span(calldata.span());

        pedersen(h1, h2).into()
    }
}