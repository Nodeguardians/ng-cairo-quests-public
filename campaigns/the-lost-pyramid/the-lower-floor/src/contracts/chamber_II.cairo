#[starknet::interface]
trait IChamberII<TContractState> {

    fn read_spellbook(self: @TContractState) -> u256;
    fn ink_balance(self: @TContractState) -> u256;
    fn is_exit_open(self: @TContractState) -> bool;
    fn add_ink(ref self: TContractState, amount: u256);
    fn use_quill(ref self: TContractState);
    
}

// "Inscribed within these pages, they key to passage lies."
// "Write the words of power, and the way shall rise."

#[starknet::contract]
mod ChamberII {

    use starknet::{ get_caller_address, get_contract_address };
    use src::contracts::interfaces::IERC20::{
        IERC20Dispatcher,
        IERC20DispatcherTrait
    };

    const INK_ADDRESS: felt252 = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;
    
    #[storage]
    struct Storage {
        spellbook: u256,
        ink_balance: u256
    }

    #[abi(embed_v0)]
    impl ChamberII_Impl of super::IChamberII<ContractState> {

        fn read_spellbook(self: @ContractState) -> u256 {
            self.spellbook.read()
        }

        fn ink_balance(self: @ContractState) -> u256 {
            self.ink_balance.read()
        }

        fn is_exit_open(self: @ContractState) -> bool {
            let spell = self.spellbook.read();
            'closed' - spell == 'open'
        }

        fn add_ink(ref self: ContractState, amount: u256) {

            let token = IERC20Dispatcher {
                contract_address: INK_ADDRESS.try_into().unwrap()
            };

            token.transfer_from(
                get_caller_address(),
                get_contract_address(),
                amount
            );

            self.ink_balance.write(
                self.ink_balance.read() + amount
            );

        }

        fn use_quill(ref self: ContractState) {
            let spell: u256 = self.ink_balance.read();
            self.spellbook.write(spell);

            self.ink_balance.write(0);
        }

    }
}