#[system]
mod remove_build {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use stark_land::components::fort_owner::FortOwner;
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
        let mut land = get!(ctx.world, (map_id, x, y), Land);
        let mut land_cost = get!(ctx.world, (map_id, x, y), LandCost);
        assert(land.level!=0, 'no building');
        // cost_gold: u64, //建筑总gold成本
        // cost_food: u64, //建筑总food成本
        // cost_iron: u64, //建筑总iron成本
        assert(
            land_cost.cost_gold != 0 || land_cost.cost_food != 0 || land_cost.cost_iron != 0, ''
        );


        let build_config = get!(ctx.world, map_id, BuildConfig);

        if (land.building == build_config.Build_Type_Fort) {
            let mut fort_owner = get!(ctx.world, (map_id, ctx.origin), FortOwner);
            fort_owner.total = fort_owner.total - 1;
            set!(ctx.world, (fort_owner));
        }

        let mut food = get!(ctx.world,(map_id,ctx.origin),Food);
        food.balance = food.balance + land_cost.cost_food * 6/10;

        let mut iron = get!(ctx.world,(map_id,ctx.origin),Iron);
        iron.balance = iron.balance + land_cost.cost_iron * 6/10;

        let mut gold = get!(ctx.world,(map_id,ctx.origin),Gold);
        gold.balance = gold.balance + land_cost.cost_gold * 6/10;

        land_cost.cost_gold = 0;
        land_cost.cost_food = 0;
        land_cost.cost_iron = 0;

        land.level = 0;
        land.building = 0;

        set!(ctx.world, (land, land_cost, food, iron, gold));
        return ();
    }
}
