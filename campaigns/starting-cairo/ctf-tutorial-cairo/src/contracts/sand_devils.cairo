#[starknet::interface]
trait ISandDevils<TContractState> {
    fn count(self: @TContractState) -> u32;
    fn slay(ref self: TContractState, amount: u32);
}

#[starknet::contract]
mod SandDevils {

    #[storage]
    struct Storage {
        count: u32
    }

    #[constructor]
    fn constructor(ref self: ContractState, count: u32) {
        self.count.write(count);
    }
    
    #[external(v0)]
    impl EndlessDesert of super::ISandDevils<ContractState> {

        fn count(self: @ContractState) -> u32 {
            self.count.read()
        }

        fn slay(ref self: ContractState, amount: u32) {
            self.count.write(
                self.count.read() - amount
            );
        }
        
    }

}