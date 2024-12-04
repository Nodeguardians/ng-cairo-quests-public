#[starknet::interface]
trait IChamberI<TContractState> {
    fn is_exit_open(self: @TContractState) -> bool;
    fn insert_keys(
        ref self: TContractState,
        key_1: felt252,
        key_2: felt252
    );
}

#[starknet::contract]
mod ChamberI {
    use core::poseidon::poseidon_hash_span;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        KeyOne: Key
    }

    #[derive(Drop, starknet::Event)]
    struct Key { number: felt252 }

    #[storage]
    struct Storage {
        key_2: felt252,
        key_hash: felt252,
        is_exit_open: bool
    }

    #[constructor]
    fn constructor(
        ref self: ContractState
    ) {
        let (key_1, key_2) = _computeKeys();

        self.emit(Key { number: key_1 });
        self.key_2.write(key_2);

        let arr = array![key_1, key_2];
        let key_hash = poseidon_hash_span(arr.span());

        self.key_hash.write(key_hash);
    }

    // This function is hidden
    fn _computeKeys() -> (felt252, felt252) {
        // ???
    }

    #[abi(embed_v0)]
    impl ChamberI_Impl of super::IChamberI<ContractState> {
        
        fn is_exit_open(self: @ContractState) -> bool {
            self.is_exit_open.read()
        }

        fn insert_keys(
            ref self: ContractState,
            key_1: felt252,
            key_2: felt252
        ) {
            let arr = array![key_1, key_2];
            let key_hash = poseidon_hash_span(arr.span());

            assert(key_hash == self.key_hash.read(), 'Wrong keys!');
            self.is_exit_open.write(true);
        }

    }
}