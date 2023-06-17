#[abi]
trait IBrainfuckVM {
    #[external]
    fn deploy(program: Array<felt252>) -> u8;
    #[view]
    fn get_program(program_id: u8) -> Array<felt252>;
    #[view]
    fn call(program_id: u8, input: Array<u8>) -> Array<u8>;
}

#[contract]
mod BrainfuckVM {
    // Implement BrainfuckVM Here
}