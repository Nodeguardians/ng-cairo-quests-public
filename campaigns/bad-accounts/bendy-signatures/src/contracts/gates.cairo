#[starknet::interface]
trait IGates<TContractState> {
    fn sphinx(self: @TContractState) -> starknet::ContractAddress;
    fn is_open(self: @TContractState) -> bool;
    fn open(ref self: TContractState);
}

#[starknet::contract]
mod Gates {

    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        sphinx: ContractAddress,
        is_open: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, sphinx: ContractAddress) {
        self.sphinx.write(sphinx);
    }

    #[abi(embed_v0)]
    impl GatesImpl of super::IGates<ContractState> {

        fn sphinx(self: @ContractState) -> ContractAddress {
            self.sphinx.read()
        }

        fn is_open(self: @ContractState) -> bool {
            self.is_open.read()
        }

        fn open(ref self: ContractState) {
            let caller = starknet::get_caller_address();
            assert(caller == self.sphinx.read(), 'NOT_SPHINX');

            self.is_open.write(true);
        }
    }

}