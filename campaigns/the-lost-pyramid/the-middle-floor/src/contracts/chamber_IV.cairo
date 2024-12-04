#[starknet::interface]
trait IChamberIV<TContractState> {

    fn is_exit_open(self: @TContractState) -> bool;

    fn silver_balance_of(
        self: @TContractState, 
        owner: starknet::ContractAddress
    ) -> u256;

    fn open_exit(ref self: TContractState);
    fn take_silver(ref self: TContractState);

    fn transfer_silver(
        ref self: TContractState, 
        to: starknet::ContractAddress, 
        amount: u256
    );
    
}

#[starknet::contract]
mod ChamberIV {

    use starknet::{
        ContractAddress,
        get_caller_address,
        storage::Map
    };

    const WEIGHT_OF_STONE: u256 = 15;

    #[storage]
    struct Storage {
        is_exit_open: bool,
        silver_balance_of: Map::<ContractAddress, u256>,
        total_silver: u256
    }

    #[abi(embed_v0)]
    impl ChamberIV_Impl of super::IChamberIV<ContractState> {
        
        fn is_exit_open(self: @ContractState) -> bool {
            self.is_exit_open.read()
        }

        fn silver_balance_of(
            self: @ContractState, 
            owner: ContractAddress
        ) -> u256 {
            self.silver_balance_of.read(owner)
        }

        // Balance the scales to open the exit...
        fn open_exit(ref self: ContractState) {
            let caller = get_caller_address();
            assert(
                self.silver_balance_of(caller) == WEIGHT_OF_STONE, 
                'Scales not balanced!' 
            );
            
            self.is_exit_open.write(true);
        }

        fn take_silver(ref self: ContractState) {
            
            assert(self.total_silver.read() < 10, 'No more silver!');

            let caller = get_caller_address();

            self.silver_balance_of.write(
                caller,
                self.silver_balance_of.read(caller) + 1
            );
            self.total_silver.write(
                self.total_silver.read() + 1
            );

        }

        fn transfer_silver(
            ref self: ContractState, 
            to: ContractAddress,
            amount: u256
        ) {
            let caller = get_caller_address();

            let from_balance = self.silver_balance_of.read(caller);
            let to_balance = self.silver_balance_of.read(to);

            self.silver_balance_of.write(caller, from_balance - amount);
            self.silver_balance_of.write(to, to_balance + amount);
        }

    }
}