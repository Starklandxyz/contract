use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(
        self: @TContractState,
        map_id: u64,
        amount: u64,
        troop_index: u64,
        from_x: u64,
        from_y: u64,
        to_x: u64,
        to_y: u64
    );
}

// dojo decorator
#[dojo::contract]
mod send_troop {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::warrior_config::WarriorConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::hbase::HBase;
    use stark_land::models::food::Food;
    use stark_land::models::iron::Iron;
    use stark_land::models::gold::Gold;
    use stark_land::models::troop::Troop;
    use stark_land::models::troop::TroopTrait;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn execute(
            self: @ContractState,
            map_id: u64,
            amount: u64,
            troop_index: u64,
            from_x: u64,
            from_y: u64,
            to_x: u64,
            to_y: u64
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let config = get!(world, map_id, WarriorConfig);
            assert(config.Train_Food != 0, 'config not ready');

            let from_land = get!(world, (map_id, from_x, from_y), Land);
            assert(from_land.owner == origin, 'not your land');

            let to_land = get!(world, (map_id, to_x, to_y), Land);

            let build_config = get!(world, map_id, BuildConfig);

            assert(
                from_land.building == build_config.Build_Type_Base
                    || from_land.building == build_config.Build_Type_Fort
                    || to_land.building == build_config.Build_Type_Base
                    || to_land.building == build_config.Build_Type_Fort,
                'not base or fort'
            );

            let to_land_type = LandTrait::land_property(map_id, to_x, to_y);
            //不能发送到金矿/铁矿/水
            assert(to_land_type >= build_config.Land_None, 'can not send troop');

            assert(from_x != to_x || from_y != to_y, 'same land');

            //如果是从自己的base出发，则不能发送给base
            if (from_land.building == build_config.Build_Type_Base) {
                assert(to_land.building != build_config.Build_Type_Base, 'can not be base');
            }
            //如果是发送到base，则必须是自己的base
            if (to_land.building == build_config.Build_Type_Base) {
                assert(to_land.owner == origin, 'not your base');
            }

            let mut warrior = get!(world, (map_id, from_x, from_y), Warrior);
            assert(warrior.balance >= amount, 'warrior not enough');

            let mut troop = get!(world, (map_id, origin, troop_index), Troop);
            assert(troop.start_time == 0, 'troop is used');

            //if from base
            let mut dis = TroopTrait::distance(from_x, from_y, to_x, to_y);
            let base = get!(world, (map_id, origin), HBase);
            //寻找到从base出发的最短路径
            if (from_land.building == build_config.Build_Type_Base) {
                if (base.x == from_x && base.y == from_y) {
                    let dis2 = TroopTrait::distance(from_x + 1, from_y, to_x, to_y);
                    if (dis > dis2) {
                        dis = dis2;
                    }
                    let dis3 = TroopTrait::distance(from_x, from_y + 1, to_x, to_y);
                    if (dis > dis3) {
                        dis = dis3;
                    }
                    let dis4 = TroopTrait::distance(from_x + 1, from_y + 1, to_x, to_y);
                    if (dis > dis4) {
                        dis = dis4;
                    }
                }
            }
            //if to base
            //寻找到到达base的最短路径
            if (to_land.building == build_config.Build_Type_Base) {
                let dis2 = TroopTrait::distance(from_x, from_y, to_x + 1, to_y);
                if (dis > dis2) {
                    dis = dis2;
                }
                let dis3 = TroopTrait::distance(from_x, from_y, to_x + 1, to_y + 1);
                if (dis > dis3) {
                    dis = dis3;
                }
                let dis4 = TroopTrait::distance(from_x, from_y, to_x, to_y + 1);
                if (dis > dis4) {
                    dis = dis4;
                }
            }

            let food_need = config.Troop_Food * amount * dis;
            let mut food = get!(world, (map_id, origin), Food);
            assert(food.balance >= food_need, 'food not enough');
            food.balance = food.balance - food_need;

            let iron_need = config.Troop_Iron * amount * dis;
            let mut iron = get!(world, (map_id, origin), Iron);
            assert(iron.balance >= iron_need, 'iron not enough');
            iron.balance = iron.balance - iron_need;

            warrior.balance = warrior.balance - amount;
            troop.start_time = time_now;
            troop.from_x = from_x;
            troop.from_y = from_y;
            troop.to_x = to_x;
            troop.to_y = to_y;
            troop.retreat = false;
            troop.balance = amount;
            troop.distance = dis;

            set!(world, (food, iron, warrior, troop));
            return ();
        }
    }
}
