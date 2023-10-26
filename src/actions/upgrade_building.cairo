use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, x: u64, y: u64);
}

// dojo decorator
#[dojo::contract]
mod upgrade_building {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

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
    use stark_land::models::upgrade_cost::UpgradeCost;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64, x: u64, y: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin =
                get_caller_address(); // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0 && base.y != 0, 'you have no base');
            let build_config = get!(world, map_id, BuildConfig);

            let mut upgrade_x = x;
            let mut upgrade_y = y;
            let mut land = get!(world, (map_id, upgrade_x, upgrade_y), Land);

            //如果传入的坐标是 Base, 就对坐标进行修正
            if (land.building == build_config.Build_Type_Base) {
                upgrade_x = base.x;
                upgrade_y = base.y;
            }
            land = get!(world, (map_id, upgrade_x, upgrade_y), Land);

            assert(
                LandTrait::land_property(map_id, upgrade_x, upgrade_y) >= build_config.Land_None,
                'can not build'
            );
            assert(land.building != 0, 'have no building');
            assert(land.owner == origin, 'not yours');

            // 判断建筑物是否正在升级
            let time_now: u64 = starknet::get_block_timestamp();
            let mut upgrade_cost = get!(world, (map_id, upgrade_x, upgrade_y), UpgradeCost);
            assert(time_now >= upgrade_cost.end_time, 'building are upgrading');
            assert(
                upgrade_cost.claimed || upgrade_cost.end_time == 0, 'claim targrt_level first '
            ); //如果上一次的级别已经claim，或是首次升级
            upgrade_cost.start_time = time_now;
            upgrade_cost.claimed = false;

            // 建设当前地块的累计成本
            let mut land_cost = get!(world, (map_id, upgrade_x, upgrade_y), LandCost);

            let build_price = get!(world, (map_id, land.building), BuildPrice);
            assert(
                build_price.food != 0 || build_price.gold != 0 || build_price.iron != 0,
                'illegal upgrade'
            );

            // 当前地块的等级
            let current_level = land.level;

            // 升级所需的时间为 单位时间 * 下一等级
            let unit_time = 300;
            let mut index = 0;
            let mut total_pow = 1;
            let mut multi = 4;
            if(land.building==build_config.Build_Type_Base){
                multi = 2;
            }
            loop {
                total_pow = total_pow * multi;
                index += 1;
                if (index == current_level) {
                    break;
                };
            };
            upgrade_cost.end_time = time_now + unit_time * total_pow / multi;

            // 升级所需的资源为 = 建设单价 * 下一等级
            let food_need = build_price.food * total_pow;
            let mut food = get!(world, (map_id, origin), Food);
            assert(food.balance >= food_need, 'food not enough');
            food.balance = food.balance - food_need;
            land_cost.cost_food = land_cost.cost_food + food_need;

            let iron_need = build_price.iron * total_pow;
            let mut iron = get!(world, (map_id, origin), Iron);
            assert(iron.balance >= iron_need, 'iron not enough');
            iron.balance = iron.balance - iron_need;
            land_cost.cost_iron = land_cost.cost_iron + iron_need;

            let gold_need = build_price.gold * total_pow;
            let mut gold = get!(world, (map_id, origin), Gold);
            assert(gold.balance >= gold_need, 'gold not enough');
            gold.balance = gold.balance - gold_need;
            land_cost.cost_gold = land_cost.cost_gold + gold_need;

            //land.level = current_level + 1;
            // 将升级后的等级暂存于 upgrade_cost
            upgrade_cost.target_level = current_level + 1;
            set!(world, (upgrade_cost, land_cost, food, iron, gold));
            return ();
        }
    }
}
