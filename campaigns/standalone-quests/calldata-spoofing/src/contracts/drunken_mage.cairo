#[starknet::interface]
trait IDrunkenMage<TContractState> {
    fn is_home(self: @TContractState) -> bool;
    fn cast_portal(
        ref self: TContractState,
        origin: Array<felt252>,
        destination: Array<felt252>
    );
}

#[starknet::contract]
mod DrunkenMage {

    use starknet::ContractAddress;

    // This isn't the right interface...
    #[starknet::interface]
    trait IDrunkenSpell<TContractState> {
        fn cast(
            ref self: TContractState,
            origin: Array<felt252>,
            destination: Array<felt252>
        ) -> bool;
    }  

    #[storage]
    struct Storage {
        spell_address: ContractAddress,
        is_home: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, spell_address: ContractAddress) {
        self.spell_address.write(spell_address);
    }

    #[abi(embed_v0)]
    impl DrunkenMageImpl of super::IDrunkenMage<ContractState> {

        fn is_home(self: @ContractState) -> bool {
            self.is_home.read()
        }

        fn cast_portal(
            ref self: ContractState, 
            origin: Array<felt252>, 
            destination: Array<felt252>
        ) {
            let drunk_spell = IDrunkenSpellDispatcher {
                contract_address: self.spell_address.read()
            };

            self.is_home.write(
                drunk_spell.cast(origin, destination)
            );
        }
        
    }

}