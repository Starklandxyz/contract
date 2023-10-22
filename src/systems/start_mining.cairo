#[system]
//对于金矿和铁矿，用户需要选择旁边的金山/铁山，开始挖矿
mod start_mining {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::land_miner::LandMiner;
    use stark_land::components::land_mining::LandMining;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
    use stark_land::components::build_config::BuildConfig;

    fn execute(ctx: Context, map_id: u64, miner_x: u64, miner_y: u64, mined_x: u64, mined_y: u64) {
        let time_now: u64 = starknet::get_block_timestamp();
        let mut land_mining = get!(ctx.world, (map_id, miner_x, miner_y), LandMining);
        assert(land_mining.start_time == 0, 'is mining');

        let build_config = get!(ctx.world, (map_id), BuildConfig);

        let miner_land = get!(ctx.world, (map_id, miner_x, miner_y), Land);
        assert(miner_land.owner==ctx.origin, 'not your land');

        if (miner_land.building == build_config.Build_Type_Farmland) {
            assert(mined_x == miner_x && mined_y == miner_y, 'wrong land');
        } else if (miner_land.building == build_config.Build_Type_IronMine
            || miner_land.building == build_config.Build_Type_GoldMine) {
            //矿场和矿山，必须挨在一起
            assert(
                miner_x >= mined_x
                    - 1 && miner_x <= mined_x
                    + 1 && miner_y >= mined_y
                    - 1 && miner_y <= mined_y
                    + 1,
                'wrong land'
            );
        } else {
            panic_with_felt252('wrong building here')
        }

        // let mined_land = get!(ctx.world, (map_id, land_x, land_y), Land);
        let land_type = LandTrait::land_property(map_id, mined_x, mined_y);

        //gold mine
        if (land_type == build_config.Land_Gold) {
            assert(miner_land.building == build_config.Build_Type_GoldMine, 'no gold mine here');
        } //iron mine
        else if (land_type <= build_config.Land_Iron) {
            assert(miner_land.building == build_config.Build_Type_IronMine, 'no iron mine here');
        } //water
        else if (land_type <= build_config.Land_Water) {
            panic_with_felt252('water')
        } else {
            assert(miner_land.building == build_config.Build_Type_Farmland, 'no farmland here');
        }

        //判断这个地块是不是已经有人在挖了
        let mut land_miner = get!(ctx.world, (map_id, mined_x, mined_y), LandMiner);
        assert(land_miner.miner_x == 0 && land_miner.miner_y == 0, 'land is occupied');

        land_miner.miner_x = miner_x;
        land_miner.miner_y = miner_y;

        land_mining.start_time = time_now;
        land_mining.mined_x = mined_x;
        land_mining.mined_y = mined_y;

        set!(ctx.world, (land_miner, land_mining));
        return ();
    }
}
