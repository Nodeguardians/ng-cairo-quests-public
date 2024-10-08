#[derive(Copy, Drop, Serde, starknet::Store)]
struct Chest {
    is_open: bool,
    owner: starknet::ContractAddress
}

#[starknet::interface]
trait ICatacombs<TContractState> {
    fn get_entry_code(self: @TContractState) -> felt252;
    fn get_brightness(self: @TContractState) -> u256;
    fn is_tile_safe(self: @TContractState, tile_id: u256) -> bool;
    fn get_chest(self: @TContractState) -> Chest;

    fn write(ref self: TContractState, slot_index: felt252, value: felt252);
}

#[starknet::contract]
mod Catacombs {
    use option::OptionTrait;
    use starknet::{ 
        storage_write_syscall, 
        storage::Map,
        SyscallResultTrait,
    };
    use traits::TryInto;

    use super::Chest;

    #[storage]
    struct Storage {
        entry_code: felt252,
        brightness: u256,
        safe_tiles: Map::<u256, bool>,
        chest: Chest
    }


    #[abi(embed_v0)]
    impl CatacombsImpl of super::ICatacombs<ContractState> {

        fn get_entry_code(self: @ContractState) -> felt252 {
            self.entry_code.read()
        }

        fn get_brightness(self: @ContractState) -> u256 {
            self.brightness.read()
        }

        fn is_tile_safe(self: @ContractState, tile_id: u256) -> bool {
            self.safe_tiles.read(tile_id)
        }

        fn get_chest(self: @ContractState) -> Chest {
            self.chest.read()
        }

        fn write(
            ref self: ContractState, 
            slot_index: felt252, 
            value: felt252
        ) {
            let storageAddress = slot_index.try_into().unwrap();
            let result = storage_write_syscall(0, storageAddress, value);

            result.unwrap_syscall();
        }
    }
}
