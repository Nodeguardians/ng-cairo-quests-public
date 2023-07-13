#[starknet::interface]
trait IRoyalSpear<TContractState> {
    fn owner(self: @TContractState) -> starknet::ContractAddress;
    fn is_equipped(self: @TContractState) -> bool;
    fn equip(ref self: TContractState, x: bool);
}

#[starknet::contract]
mod RoyalSpear {

    use starknet::{ ContractAddress, get_caller_address };

    #[storage]
    struct Storage {
        owner: ContractAddress,
        is_equipped: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.is_equipped.write(true);
    }

    #[external(v0)]
    impl RoyalSpearImpl of super::IRoyalSpear<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn is_equipped(self: @ContractState) -> bool {
            self.is_equipped.read()
        }

        fn equip(ref self: ContractState, x: bool) {
            assert(get_caller_address() == self.owner.read(), 'NOT_OWNER');
            self.is_equipped.write(x);
        }
    }

}
