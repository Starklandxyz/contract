use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState);
}

// dojo decorator
#[dojo::contract]
mod init {
    use super::IActions;
    use starknet::{ContractAddress, get_caller_address};
    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::warrior_config::WarriorConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::build_price::BuildPrice;
    use stark_land::models::mining_config::MiningConfig;
    use stark_land::models::airdrop_config::AirdropConfig;

    #[event]
    use stark_land::events::inited::{Event, MapInited};

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState) {
            let max_map_x: u64 = 100;
            let max_map_y: u64 = 100;
            let multiplier: u64 = 1_000_000;
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            set!(
                world,
                (
                    GlobalConfig {
                        map_id: 1,
                        MULTIPLIER: multiplier,
                        MAX_MAP_X: max_map_x,
                        MAX_MAP_Y: max_map_y
                    },
                )
            );
            set!(
                world,
                (
                    WarriorConfig {
                        map_id: 1,
                        Train_Food: 20 * multiplier,
                        Train_Gold: 10 * multiplier,
                        Train_Iron: 2 * multiplier,
                        Train_Time: 60,
                        Troop_Food: 10 * multiplier,
                        Troop_Iron: 1 * multiplier,
                        Troop_Gold: 0 * multiplier,
                        Troop_Speed: 30
                    },
                )
            );
            set!(
                world,
                (BuildConfig {
                    map_id: 1,
                    Land_Gold: 1, //土地属性是金矿的值,默认是1
                    Land_Iron: 4, //土地属性是铁矿的值,默认是4,(2,3,4都是铁矿)
                    Land_Water: 7, //土地属性是水的值,默认是7,(5,6,7都是水)
                    Land_None: 8, //土地属性是可建设用地的值,默认是8
                    // 1==基地Base 4*4,2==农田Farmland,3==铁矿矿场IronMine,4==金矿矿场GoldMine,5==营地Camp
                    Build_Type_Base: 1,
                    Build_Type_Farmland: 2,
                    Build_Type_IronMine: 3,
                    Build_Type_GoldMine: 4,
                    Build_Type_Camp: 5,
                    Build_Type_Fort: 6,
                })
            );
            set!(
                world,
                (MiningConfig {
                    map_id: 1,
                    Food_Speed: multiplier / 2, // 0.2 per sec
                    Gold_Speed: multiplier / 2, //
                    Iron_Speed: multiplier / 2, //
                    Base_Gold_Speed: multiplier / 2,
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 1,
                    gold: 1000 * multiplier,
                    food: 5000 * multiplier,
                    iron: 1000 * multiplier
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 2,
                    gold: 500 * multiplier,
                    food: 1000 * multiplier,
                    iron: 500 * multiplier
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 3,
                    gold: 500 * multiplier,
                    food: 1000 * multiplier,
                    iron: 500 * multiplier
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 4,
                    gold: 500 * multiplier,
                    food: 1000 * multiplier,
                    iron: 500 * multiplier
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 5,
                    gold: 500 * multiplier,
                    food: 1000 * multiplier,
                    iron: 500 * multiplier
                })
            );
            set!(
                world,
                (BuildPrice {
                    map_id: 1,
                    build_type: 6,
                    gold: 1000 * multiplier,
                    food: 10000 * multiplier,
                    iron: 1000 * multiplier
                })
            );

            emit!(world, MapInited { map_id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y });
            let airdropMulti = 2;
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 1,
                    reward_warrior: 10 * airdropMulti,
                    reward_food: 3000 * multiplier * airdropMulti,
                    reward_gold: 500 * multiplier * airdropMulti,
                    reward_iron: 500 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 2,
                    reward_warrior: 0,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 500 * multiplier * airdropMulti,
                    reward_iron: 500 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 3,
                    reward_warrior: 10 * airdropMulti,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 300 * multiplier * airdropMulti,
                    reward_iron: 300 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 4,
                    reward_warrior: 20 * airdropMulti,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 300 * multiplier * airdropMulti,
                    reward_iron: 300 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 5,
                    reward_warrior: 0,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 500 * multiplier * airdropMulti,
                    reward_iron: 0 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 6,
                    reward_warrior: 0,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 500 * multiplier * airdropMulti,
                    reward_iron: 0 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 7,
                    reward_warrior: 0,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 00 * multiplier * airdropMulti,
                    reward_iron: 500 * multiplier * airdropMulti
                })
            );
            set!(
                world,
                (AirdropConfig {
                    map_id: 1,
                    index: 8,
                    reward_warrior: 20,
                    reward_food: 2000 * multiplier * airdropMulti,
                    reward_gold: 500 * multiplier * airdropMulti,
                    reward_iron: 500 * multiplier * airdropMulti
                })
            );
            return ();
        }
    }
}
