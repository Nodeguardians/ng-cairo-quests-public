#[starknet::interface]
trait IChamberVI<TContractState> {
    fn is_exit_open(self: @TContractState) -> bool;
    fn run_across_bridge(ref self: TContractState);
    fn try_again(ref self: TContractState);
}

#[starknet::interface]
trait IPlayer<TContractState> {
    fn speed(self: @TContractState) -> u32;
}

#[starknet::contract]
mod ChamberVI {

    use starknet::get_caller_address;
    use super::{ IPlayerDispatcher, IPlayerDispatcherTrait };

    #[derive(Drop, starknet::Store)]
    enum BridgeCondition {
        Normal,
        Breaking,
        Broken
    }

    #[storage]
    struct Storage {
        distance_travelled: u32,
        bridge_condition: BridgeCondition
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.bridge_condition.write(BridgeCondition::Normal);
    }

    #[abi(embed_v0)]
    impl ChamberVI_Impl of super::IChamberVI<ContractState> {

        fn is_exit_open(self: @ContractState) -> bool {
            self.distance_travelled.read() >= 100
        }

        fn run_across_bridge(ref self: ContractState) {

            let player = super::IPlayerDispatcher {
                contract_address: get_caller_address()
            };

            // The bridge is slowly breaking... There is no time!
            let new_condition = match self.bridge_condition.read() {
                BridgeCondition::Normal => BridgeCondition::Breaking,
                BridgeCondition::Breaking => BridgeCondition::Broken,
                BridgeCondition::Broken => panic_with_felt252('The bridge is broken!')
            };

            self.bridge_condition.write(new_condition);

            let speed = player.speed();

            assert(speed > 30, 'Too slow!');
            assert(speed < 50, 'Too fast!');

            self.distance_travelled.write(
                self.distance_travelled.read() + speed
            );
            
        }

        // Call this to reset chamber state to try again!
        fn try_again(ref self: ContractState) {
            self.bridge_condition.write(BridgeCondition::Normal);
            self.distance_travelled.write(0);
        }

    }
}