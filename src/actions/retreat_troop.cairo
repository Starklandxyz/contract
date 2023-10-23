use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, troop_index: u64);
}

// dojo decorator
#[dojo::contract]
mod retreat_troop {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::warrior_config::WarriorConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::land::Land;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::hbase::HBase;
    use stark_land::models::troop::Troop;
    use stark_land::models::troop::TroopTrait;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn execute(
            self: @ContractState,
            map_id: u64, troop_index: u64
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let config = get!(world, map_id, WarriorConfig);
            assert(config.Train_Food != 0, 'config not ready');

            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0, 'no base');

            let mut troop = get!(world, (map_id, origin, troop_index), Troop);
            assert(troop.start_time != 0, 'no troop');
            assert(!troop.retreat, 'is retreating');

            let build_config = get!(world, map_id, BuildConfig);
            let to_land = get!(world, (map_id, troop.to_x, troop.to_y), Land);
            //如果终点是Base，则不能撤退
            assert(to_land.building != build_config.Build_Type_Base, 'can not retreat');

            troop.retreat = true;

            let total_time = troop.distance * config.Troop_Speed;
            //at the end of the troop
            if (time_now - troop.start_time > total_time) {
                troop.start_time = time_now;
            } else {
                troop.start_time = time_now - total_time + time_now - troop.start_time;
            }

            let from_x = troop.from_x;
            let from_y = troop.from_y;

            troop.from_x = troop.to_x;
            troop.from_y = troop.to_y;
            troop.to_x = from_x;
            troop.to_y = from_y;

            set!(world, (troop));
            return ();
        }
    }
}
