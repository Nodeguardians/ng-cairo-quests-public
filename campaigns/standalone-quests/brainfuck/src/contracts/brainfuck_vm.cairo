#[starknet::interface]
trait IBrainfuckVM<TContractState> {
    fn deploy(ref self: TContractState, program: Array<felt252>) -> u8;
    fn get_program(self: @TContractState, program_id: u8) -> Array<felt252>;
    fn call(self: @TContractState, program_id: u8, input: Array<u8>) -> Array<u8>;
}

#[starknet::contract]
mod BrainfuckVM {
    // Implement BrainfuckVM Here
    #[storage]
    struct Storage { }
}