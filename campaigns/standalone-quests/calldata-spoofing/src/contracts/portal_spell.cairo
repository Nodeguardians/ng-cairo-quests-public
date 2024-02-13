#[derive(Drop, Serde)]
struct PortalData {
    location: felt252,
    details: Array<felt252>
}

#[starknet::interface]
trait IPortalSpell<TContractState> {
    fn cast(
        self: @TContractState, 
        portal_data: Array<PortalData>
    ) -> bool;
}

#[starknet::contract]
mod PortalSpell {
    
    use array::ArrayTrait;
    use option::OptionTrait;

    use super::PortalData;

    #[storage]
    struct Storage { }

    #[abi(embed_v0)]
    impl PortalSpellImpl of super::IPortalSpell<ContractState> {
        // Returns true if given the correct portal_data...
        fn cast(self: @ContractState, portal_data: Array<PortalData>) -> bool {
            check_origin(portal_data[0]) 
                && check_destination(portal_data[1])
        }
    }

    fn check_origin(portal_data: @PortalData) -> bool {
        *portal_data.location == 'TAVERN' 
            && portal_data.details.len() == 2
            && *portal_data.details[0] == 'OPEN'
            && *portal_data.details[1] == 'PORTAL'
    }

    fn check_destination(portal_data: @PortalData) -> bool {
        *portal_data.location == 'HOME' 
            && portal_data.details.len() == 2
            && *portal_data.details[0] == 'CLOSE'
            && *portal_data.details[1] == 'PORTAL'
    }
}