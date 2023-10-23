use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(
        self: @TContractState, map_id: u64, miner_x: u64, miner_y: u64, mined_x: u64, mined_y: u64
    );
}

// dojo decorator
#[dojo::contract]
//对于金矿和铁矿，用户需要选择旁边的金山/铁山，开始挖矿
mod start_mining {
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;

    use stark_land::models::land_miner::LandMiner;
    use stark_land::models::land_mining::LandMining;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::build_config::BuildConfig;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64, miner_x: u64, miner_y: u64, mined_x: u64, mined_y: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let mut land_mining = get!(world, (map_id, miner_x, miner_y), LandMining);
            assert(land_mining.start_time == 0, 'is mining');

            let build_config = get!(world, (map_id), BuildConfig);

            let miner_land = get!(world, (map_id, miner_x, miner_y), Land);
            assert(miner_land.owner == origin, 'not your land');

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

            // let mined_land = get!(world, (map_id, land_x, land_y), Land);
            let land_type = LandTrait::land_property(map_id, mined_x, mined_y);

            //gold mine
            if (land_type == build_config.Land_Gold) {
                assert(
                    miner_land.building == build_config.Build_Type_GoldMine, 'no gold mine here'
                );
            } //iron mine
            else if (land_type <= build_config.Land_Iron) {
                assert(
                    miner_land.building == build_config.Build_Type_IronMine, 'no iron mine here'
                );
            } //water
            else if (land_type <= build_config.Land_Water) {
                panic_with_felt252('water')
            } else {
                assert(miner_land.building == build_config.Build_Type_Farmland, 'no farmland here');
            }

            //判断这个地块是不是已经有人在挖了
            let mut land_miner = get!(world, (map_id, mined_x, mined_y), LandMiner);
            assert(land_miner.miner_x == 0 && land_miner.miner_y == 0, 'land is occupied');

            land_miner.miner_x = miner_x;
            land_miner.miner_y = miner_y;

            land_mining.start_time = time_now;
            land_mining.mined_x = mined_x;
            land_mining.mined_y = mined_y;

            set!(world, (land_miner, land_mining));
            return ();
        }
    }
}
