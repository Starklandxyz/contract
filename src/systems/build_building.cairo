#[system]
mod build_building {
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

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64, build_type: u64) {
        // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x != 0 && base.y != 0, 'you have no base');

        let build_config = get!(ctx.world, map_id, BuildConfig);

        let mut land = get!(ctx.world, (map_id, x, y), Land);
        assert(LandTrait::land_property(map_id, x, y) >= build_config.Land_None, 'can not build');
        assert(land.building == 0, 'has building');
        assert(land.owner == ctx.origin, 'not yours');
        // assert((build_type >= build_config.Build_Type_Farmland) && 
        // (build_type <= build_config.Build_Type_Camp), 'illegal build_type');

        let mut land_cost = get!(ctx.world, (map_id, x, y), LandCost);

        let build_price = get!(ctx.world, (map_id, build_type), BuildPrice);
        let food_need = build_price.food;
        let iron_need = build_price.iron;
        let gold_need = build_price.gold;
        assert(food_need != 0 || iron_need != 0 || gold_need != 0, 'wrong build');

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        assert(food.balance >= food_need, 'food not enough');
        food.balance = food.balance - food_need;
        land_cost.cost_food = land_cost.cost_food + food_need;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        assert(iron.balance >= iron_need, 'iron not enough');
        iron.balance = iron.balance - iron_need;
        land_cost.cost_iron = land_cost.cost_iron + iron_need;

        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        assert(gold.balance >= gold_need, 'gold not enough');
        gold.balance = gold.balance - gold_need;
        land_cost.cost_gold = land_cost.cost_gold + gold_need;

        land.building = build_type;
        land.level = 1;

        set!(ctx.world, (land, land_cost, food, iron, gold));
        return ();
    }
}
