#[system]
mod upgrade_building {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::build_config::BuildConfig;
    use stark_land::components::build_price::BuildPrice;
    use stark_land::components::player::Player;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::gold::Gold;
    use stark_land::components::base::Base;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
    use stark_land::components::land_cost::LandCost;
    use stark_land::components::upgrade_cost::UpgradeCost;

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x != 0 && base.y != 0, 'you have no base');
        let build_config = get!(ctx.world, map_id, BuildConfig);

        let mut upgrade_x = x;
        let mut upgrade_y = y;
        let mut land = get!(ctx.world, (map_id, upgrade_x, upgrade_y), Land);

        //如果传入的坐标是 Base, 就对坐标进行修正
        if(land.building == build_config.Build_Type_Base){
            upgrade_x = base.x;
            upgrade_y = base.y;
        }
        land = get!(ctx.world, (map_id, upgrade_x, upgrade_y), Land);

        assert(LandTrait::land_property(map_id, upgrade_x, upgrade_y) >= build_config.Land_None, 'can not build');
        assert(land.building != 0, 'have no building');
        assert(land.owner == ctx.origin, 'not yours');

        // 判断建筑物是否正在升级
        let time_now: u64 = starknet::get_block_timestamp();
        let mut upgrade_cost = get!(ctx.world,(map_id,upgrade_x, upgrade_y),UpgradeCost);
        assert(time_now >= upgrade_cost.end_time, 'building are upgrading');
        assert(upgrade_cost.claimed || upgrade_cost.end_time==0, 
        'claim targrt_level first ');//如果上一次的级别已经claim，或是首次升级
        upgrade_cost.start_time = time_now;
        upgrade_cost.claimed = false;

        // 建设当前地块的累计成本
        let mut land_cost = get!(ctx.world,(map_id,upgrade_x, upgrade_y),LandCost);

        let build_price = get!(ctx.world,(map_id, land.building),BuildPrice);
        assert(
            build_price.food != 0 || build_price.gold != 0 || build_price.iron != 0, 'illegal upgrade'
        );

        // 当前地块的等级
        let  current_level = land.level;
        // 升级所需的资源为 = 建设单价 * 下一等级
        let food_need = build_price.food * (current_level + 1);
        // 升级所需的时间为 单位时间 * 下一等级
        let unit_time = 100;
        upgrade_cost.end_time = time_now + unit_time * (current_level + 1);

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        assert(food.balance >= food_need, 'food not enough');
        food.balance = food.balance - food_need;
        land_cost.cost_food = land_cost.cost_food + food_need;

        let iron_need = build_price.iron * (current_level + 1);
        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        assert(iron.balance >= iron_need, 'iron not enough');
        iron.balance = iron.balance - iron_need;
        land_cost.cost_iron = land_cost.cost_iron + iron_need;

        let gold_need = build_price.gold * (current_level + 1);
        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        assert(gold.balance >= gold_need, 'gold not enough');
        gold.balance = gold.balance - gold_need;
        land_cost.cost_gold = land_cost.cost_gold + gold_need;

        //land.level = current_level + 1;
        // 将升级后的等级暂存于 upgrade_cost
        upgrade_cost.target_level = current_level + 1;
        set!(ctx.world, (upgrade_cost,land_cost,food,iron,gold));
        return ();
    }
}