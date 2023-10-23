use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, x: u64, y: u64);
}

// dojo decorator
#[dojo::contract]
mod remove_build {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use super::IActions;
    use starknet::{ContractAddress, get_caller_address};
    use starknet::contract_address_const;

    use stark_land::models::fort_owner::FortOwner;
    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::build_price::BuildPrice;
    use stark_land::models::land_mining::LandMining;
    use stark_land::models::player::Player;
    use stark_land::models::food::Food;
    use stark_land::models::iron::Iron;
    use stark_land::models::gold::Gold;
    use stark_land::models::land::Land;
    use stark_land::models::land_miner::LandMiner;
    use stark_land::models::land::LandTrait;
    use stark_land::models::land_cost::LandCost;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(
            self: @ContractState,  map_id: u64, x: u64, y: u64
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            // assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');
            let mut land = get!(world, (map_id, x, y), Land);
            let mut land_cost = get!(world, (map_id, x, y), LandCost);
            assert(land.level != 0, 'no building');
            // cost_gold: u64, //建筑总gold成本
            // cost_food: u64, //建筑总food成本
            // cost_iron: u64, //建筑总iron成本
            assert(
                land_cost.cost_gold != 0 || land_cost.cost_food != 0 || land_cost.cost_iron != 0, ''
            );

            //获取挖矿信息
            let mut land_mining = get!(world, (map_id, x, y), LandMining);
            //获取被挖矿的位置
            let mut land_miner = get!(
                world, (map_id, land_mining.mined_x, land_mining.mined_y), LandMiner
            );

            land_miner.miner_x = 0;
            land_miner.miner_y = 0;
            land_mining.start_time = 0;
            land_mining.mined_x = 0;
            land_mining.mined_y = 0;

            let build_config = get!(world, map_id, BuildConfig);

            if (land.building == build_config.Build_Type_Fort) {
                let mut fort_owner = get!(world, (map_id, origin), FortOwner);
                fort_owner.total = fort_owner.total - 1;
                set!(world, (fort_owner));
            }

            let mut food = get!(world, (map_id, origin), Food);
            food.balance = food.balance + land_cost.cost_food * 6 / 10;

            let mut iron = get!(world, (map_id, origin), Iron);
            iron.balance = iron.balance + land_cost.cost_iron * 6 / 10;

            let mut gold = get!(world, (map_id, origin), Gold);
            gold.balance = gold.balance + land_cost.cost_gold * 6 / 10;

            land_cost.cost_gold = 0;
            land_cost.cost_food = 0;
            land_cost.cost_iron = 0;

            land.level = 0;
            land.building = 0;

            set!(world, (land, land_miner, land_mining, land_cost, food, iron, gold));
            return ();
        }
    }
}
