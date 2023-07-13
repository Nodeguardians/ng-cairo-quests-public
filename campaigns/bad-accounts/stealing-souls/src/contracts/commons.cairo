use starknet::{ account::Call, ContractAddress };

#[starknet::interface]
trait ITombkeeper<TContractState> {
    fn __validate__(ref self: TContractState, calls: Array<Call>) -> felt252;

    fn __execute__(ref self: TContractState, calls: Array<Call>) -> Array<Span<felt252>>;
    
    fn soul_token(self: @TContractState) -> ContractAddress;
    fn soul_vault(self: @TContractState) -> ContractAddress;
}
