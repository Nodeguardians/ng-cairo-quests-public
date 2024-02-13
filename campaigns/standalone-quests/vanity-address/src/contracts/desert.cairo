#[starknet::interface]
trait IDesert<TContractState> {
    fn is_oasis_found(self: @TContractState) -> bool;
    fn find_oasis(ref self: TContractState);
}

#[starknet::contract]
mod EndlessDesert {
    
    use starknet::{ ContractAddress, get_caller_address };
    use traits::Into;

    use super::IDesert;

    #[storage]
    struct Storage {
        is_oasis_found: bool,
    }
    
    #[abi(embed_v0)]
    impl EndlessDesert of IDesert<ContractState> {

        fn is_oasis_found(self: @ContractState) -> bool {
            self.is_oasis_found.read()
        }

        fn find_oasis(ref self: ContractState) {
            let caller = get_caller_address();

            assert(is_oasis(caller), 'NOT_OASIS');
            self.is_oasis_found.write(true);
        }
        
    }
    
    #[inline(always)]
    fn is_oasis(address: ContractAddress) -> bool {
        let addr_as_felt: felt252 = address.into();
        let addr_as_u256: u256 = addr_as_felt.into();

        let prefix = addr_as_u256.high / 0x1000000000000000000000000000;
        prefix == 0x04515
    }

}