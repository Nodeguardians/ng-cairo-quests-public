#[starknet::interface]
trait IChamberV<TContractState> {
    fn is_exit_open(self: @TContractState) -> bool;
    fn snipe_block(
        ref self: TContractState, 
        fireball_class: starknet::ClassHash
    );
}

#[starknet::interface]
trait IFireball<TContractState> {
    fn find_target(ref self: TContractState) -> u64;
}

#[starknet::contract]
mod ChamberV {

    use core::starknet::{ ClassHash, get_block_number };

    use super::{
        IFireballLibraryDispatcher,
        IFireballDispatcherTrait
    };

    #[storage]
    struct Storage {
        target: u64
    }

    #[abi(embed_v0)]
    impl ChamberV_Impl of super::IChamberV<ContractState> {

        fn is_exit_open(self: @ContractState) -> bool {
            let target = self.target.read();
            target * target * target == get_block_number()
        }
        
        fn snipe_block(ref self: ContractState, fireball_class: ClassHash) {
            let fireball = IFireballLibraryDispatcher { 
                class_hash: fireball_class 
            };
            self.target.write(fireball.find_target());
        }

    }
}