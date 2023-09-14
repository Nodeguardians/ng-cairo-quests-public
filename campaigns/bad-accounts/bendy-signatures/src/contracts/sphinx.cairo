#[starknet::interface]
trait AccountContract<TContractState> {
    fn __validate_declare__(self: @TContractState, class_hash: felt252) -> felt252;
    fn __validate__(ref self: TContractState, calls: Array<starknet::account::Call>) -> felt252;
    fn __execute__(ref self: TContractState, calls: Array<starknet::account::Call>) -> Array<Span<felt252>>;
}

#[starknet::contract]
mod Sphinx {

    use array::{ ArrayTrait, SpanTrait };
    use box::BoxTrait;
    use ecdsa::check_ecdsa_signature;
    use option::OptionTrait;
    use zeroable::Zeroable;

    use starknet::account::Call;
    
    const RIDDLE_1: felt252 = 0x647f8da1b20d23471c304fe5191505b40ab01e7c2e177166060a752690004d3;
    const RIDDLE_2: felt252 = 0x2b9661c2ffe97c513f34fe0be505897483feade5cb4cb1a1dd438cbc5dcb715;
    const RIDDLE_3: felt252 = 0x6cae0d16793fc4d26c13dfe8a52bbaa9913fc10e4de0ab91a796dfd011c1a3b;

    #[storage]
    struct Storage {
        used_sigs: LegacyMap<(felt252, felt252), bool>
    }

    #[external(v0)]
    impl AccountImpl of super::AccountContract<ContractState> {

        fn __validate_declare__(self: @ContractState, class_hash: felt252) -> felt252 {
            0 // Declaration not supported
        }

        fn __validate__(ref self: ContractState, calls: Array<Call>) -> felt252 {
            let tx_info = starknet::get_tx_info().unbox();
            let raw_sig = tx_info.signature;
            
            assert(raw_sig.len() == 6, 'INVALID_SIGNATURE_LENGTH');

            let mut i = 0;
            loop {
                if i == 6 { break; }

                let riddle = *raw_sig[i];
                let r = *raw_sig[i + 1];
                let s = *raw_sig[i + 2];

                assert(is_riddle(riddle), 'INVALID_RIDDLE');
                assert(!self.used_sigs.read((r, s)), 'REPLAYED_SIGNATURE');

                let is_valid = check_ecdsa_signature(
                    message_hash: tx_info.transaction_hash, 
                    public_key: riddle,
                    signature_r: r,
                    signature_s: s
                );

                assert(is_valid, 'INVALID_SIGNATURE');

                self.used_sigs.write((r, s), true);
                i += 3;
            };

            starknet::VALIDATED
        }

        fn __execute__(ref self: ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            assert(starknet::get_caller_address().is_zero(), 'INVALID_CALLER');
            assert(calls.len() == 1, 'MULTICALL_NOT_SUPPORTED');

            let Call { to, selector, calldata } = calls.pop_front().unwrap();
            let call_result = starknet::call_contract_syscall(
                to, selector, calldata.span()
            );

            let mut results = ArrayTrait::new();
            results.append(call_result.unwrap());

            results
        }
    }

    #[inline(always)]
    fn is_riddle(public_key: felt252) -> bool {
        public_key == RIDDLE_1 || public_key == RIDDLE_2 || public_key == RIDDLE_3
    }
}