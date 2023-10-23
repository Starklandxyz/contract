use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, xs: Array<u64>, ys: Array<u64>);
}

// dojo decorator
#[dojo::contract]
mod claim_mining {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::food::Food;
    use stark_land::models::gold::Gold;
    use stark_land::models::iron::Iron;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::land_mining::LandMining;
    use stark_land::models::mining_config::MiningConfig;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(
            self: @ContractState,
            map_id: u64, xs: Array<u64>, ys: Array<u64>
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            assert(xs.len() == ys.len(), 'wrong index');

            let mut index = 0;
            let len = xs.len();
            let mut add_gold = 0;
            let mut add_iron = 0;
            let mut add_food = 0;
            let building_config = get!(world, map_id, BuildConfig);
            let mining_config = get!(world, map_id, MiningConfig);
            loop {
                let x: u64 = *xs.at(index);
                let y: u64 = *ys.at(index);
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not owner');

                let mut land_mining = get!(world, (map_id, x, y), LandMining);

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
                    } else if (land.building == building_config.Build_Type_Base) {
                        let reward = total_time * mining_config.Base_Gold_Speed;
                        add_gold += reward;
                    }
                    land_mining.start_time = time_now;
                    set!(world, (land_mining));
                }

                index += 1;
                if (index == len) {
                    break ();
                };
            };
            if (add_food != 0) {
                let mut food = get!(world, (map_id, origin), Food);
                food.balance = food.balance + add_food;
                set!(world, (food));
            }

            if (add_iron != 0) {
                let mut iron = get!(world, (map_id, origin), Iron);
                iron.balance = iron.balance + add_iron;
                set!(world, (iron));
            }
            if (add_gold != 0) {
                let mut gold = get!(world, (map_id, origin), Gold);
                gold.balance = gold.balance + add_gold;
                set!(world, (gold));
            }
            return ();
        }
    }
}
