#[system]
mod claim_mining {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::build_config::BuildConfig;
    use stark_land::components::food::Food;
    use stark_land::components::gold::Gold;
    use stark_land::components::iron::Iron;
    use stark_land::components::base::Base;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
    use stark_land::components::land_mining::LandMining;
    use stark_land::components::mining_config::MiningConfig;

    fn execute(ctx: Context, map_id: u64, xs: Array<u64>, ys: Array<u64>) {
        assert(xs.len() == ys.len(), 'wrong index');
        let time_now: u64 = starknet::get_block_timestamp();
        
        let mut index = 0;
        let len = xs.len();
        let mut add_gold = 0;
        let mut add_iron = 0;
        let mut add_food = 0;
        let building_config = get!(ctx.world, map_id, BuildConfig);
        let mining_config = get!(ctx.world, map_id, MiningConfig);
        loop {
            let x:u64 = *xs.at(index);
            let y:u64 = *ys.at(index);
            let land = get!(ctx.world, (map_id, x, y), Land);
            assert(land.owner == ctx.origin, 'not owner');

            let mut land_mining = get!(ctx.world, (map_id, x, y), LandMining);

            if (land_mining.start_time != 0) {
                let total_time = time_now - land_mining.start_time;
                if (land.building == building_config.Build_Type_Farmland) {
                    let reward = total_time * mining_config.Food_Speed;
                    add_food += reward; 
                } else if (land.building == building_config.Build_Type_IronMine) {
                    let reward = total_time * mining_config.Iron_Speed;
                    add_iron += reward; 
                } else if (land.building == building_config.Build_Type_GoldMine) {
                    let reward = total_time * mining_config.Gold_Speed;
                    add_gold += reward; 
                }else if (land.building == building_config.Build_Type_Base) {
                    let reward = total_time * mining_config.Base_Gold_Speed;
                    add_gold += reward;
                }
                land_mining.start_time = time_now;
                set!(ctx.world, (land_mining));
            }

            index += 1;
            if (index == len) {
                break ();
            };
        };
        if(add_food != 0){
            let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
            food.balance = food.balance + add_food;
            set!(ctx.world, (food));
        }

        if(add_iron!=0){
            let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
            iron.balance = iron.balance + add_iron;
            set!(ctx.world, (iron));
        }
        if(add_gold!=0){
            let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
            gold.balance = gold.balance + add_gold;
            set!(ctx.world, (gold));
        }
        return ();
    }

}
