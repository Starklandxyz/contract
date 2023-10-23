use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64);
}

// dojo decorator
#[dojo::contract]
mod take_warrior {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::training::Training;
    use stark_land::models::training::TrainImpl;

    use stark_land::models::hbase::HBase;
    use stark_land::models::user_warrior::UserWarrior;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::warrior_config::WarriorConfig;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let mut training = get!(world, (map_id, origin), Training);

            let config = get!(world, map_id, WarriorConfig);
            assert(config.Train_Food != 0, 'config not ready');

            let amount = training.can_take_out_amount(config.Train_Time, time_now);
            assert(amount != 0, 'not claimable');

            training.out = training.out + amount;

            let base = get!(world, (map_id, origin), HBase);
            let mut warrior = get!(world, (map_id, base.x, base.y), Warrior);
            warrior.balance = warrior.balance + amount;

            let mut user_warrior = get!(world, (map_id, origin), UserWarrior);
            user_warrior.balance = user_warrior.balance + amount;

            set!(world, (training, warrior, user_warrior));
        }
    }
}
