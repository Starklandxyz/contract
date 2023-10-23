use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, x: u64, y: u64, build_type: u64);
}

// dojo decorator
#[dojo::contract]
mod build_building {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::fort_owner::FortOwner;
    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::build_price::BuildPrice;
    use stark_land::models::player::Player;
    use stark_land::models::food::Food;
    use stark_land::models::iron::Iron;
    use stark_land::models::gold::Gold;
    use stark_land::models::hbase::HBase;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::land_cost::LandCost;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn execute(self: @ContractState,  map_id: u64, x: u64, y: u64, build_type: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0 && base.y != 0, 'you have no base');

            let build_config = get!(world, map_id, BuildConfig);

            if (build_type == build_config.Build_Type_Fort) {
                let base_land = get!(world, (map_id, base.x, base.y), Land);
                let mut fort_owner = get!(world, (map_id, origin), FortOwner);
                assert(fort_owner.total < base_land.level / 2, 'exceed max fort.');
                fort_owner.total = fort_owner.total + 1;
                set!(world, (fort_owner));
            }

            let mut land = get!(world, (map_id, x, y), Land);
            assert(
                LandTrait::land_property(map_id, x, y) >= build_config.Land_None, 'can not build'
            );
            assert(land.building == 0, 'has building');
            assert(land.owner == origin, 'not yours');

            let mut land_cost = get!(world, (map_id, x, y), LandCost);

            let build_price = get!(world, (map_id, build_type), BuildPrice);
            let food_need = build_price.food;
            let iron_need = build_price.iron;
            let gold_need = build_price.gold;
            assert(food_need != 0 || iron_need != 0 || gold_need != 0, 'wrong build');

            let mut food = get!(world, (map_id, origin), Food);
            assert(food.balance >= food_need, 'food not enough');
            food.balance = food.balance - food_need;
            land_cost.cost_food = land_cost.cost_food + food_need;

            let mut iron = get!(world, (map_id, origin), Iron);
            assert(iron.balance >= iron_need, 'iron not enough');
            iron.balance = iron.balance - iron_need;
            land_cost.cost_iron = land_cost.cost_iron + iron_need;

            let mut gold = get!(world, (map_id, origin), Gold);
            assert(gold.balance >= gold_need, 'gold not enough');
            gold.balance = gold.balance - gold_need;
            land_cost.cost_gold = land_cost.cost_gold + gold_need;

            land.building = build_type;
            land.level = 1;

            set!(world, (land, land_cost, food, iron, gold));
            return ();
        }
    }
}
