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

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x != 0 && base.y != 0, 'you have no base');
        let build_config = get!(ctx.world, map_id, BuildConfig);

        let mut land = get!(ctx.world, (map_id, x, y), Land);
        assert(LandTrait::land_property(map_id, x, y) >= build_config.Land_None, 'can not build');
        //assert(land.building != 0, 'have no building');
        assert((land.building >=2) && (land.building <=5), 'illegal build_type');
        assert((land.building >= build_config.Build_Type_Farmland) && 
        (land.building <= build_config.Build_Type_Camp), 'illegal build_type');
        assert(land.owner == ctx.origin, 'not yours');


        // 建设当前地块的累计成本
        let mut land_cost = get!(ctx.world,(map_id,x,y),LandCost);


        let build_price = get!(ctx.world,(map_id, land.building),BuildPrice);
        // 当前地块的等级
        let current_level = land.level;
        // 升级所需的资源为 = 建设单价 * 下一等级
        let food_need = build_price.food * (current_level + 1);

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

        land.level = current_level + 1;


        set!(ctx.world, (land,land_cost,food,iron,gold));
        return ();
    }
}
