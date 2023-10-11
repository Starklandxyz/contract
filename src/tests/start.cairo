#[cfg(test)]
mod test {
    use traits::{Into, TryInto};
    use core::result::ResultTrait;
    use array::{ArrayTrait, SpanTrait};
    use option::OptionTrait;
    use box::BoxTrait;
    use clone::Clone;
    use debug::PrintTrait;
    use starknet::{ContractAddress, get_block_timestamp, get_caller_address};

    // dojo core imports
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::spawn_test_world;

    // project imports
    // components
    use stark_land::components::base::{Base, base};
    use stark_land::components::user_warrior::{UserWarrior, user_warrior};
    use stark_land::components::warrior::{Warrior, warrior};
    use stark_land::components::warrior_config::{WarriorConfig, warrior_config};
    use stark_land::components::global_config::{GlobalConfig, global_config};
    use stark_land::components::player::{Player, player};
    use stark_land::components::troop::{troop, TroopImpl};
    use stark_land::components::land::{land, LandTrait};

    use stark_land::utils::random::{random};

    // systems
    use stark_land::systems::spawn::{spawn};
    use stark_land::systems::init::{init};
    use stark_land::systems::build_base::{build_base};
    use stark_land::systems::train_warrior::{train_warrior};
    use stark_land::systems::take_warrior:: {take_warrior};
    use stark_land::systems::airdrop:: {airdrop};
    

    // components   
    fn setup() -> IWorldDispatcher {
        let mut components = array![
            base::TEST_CLASS_HASH,
            user_warrior::TEST_CLASS_HASH,
            warrior::TEST_CLASS_HASH,
            warrior_config::TEST_CLASS_HASH,
        ];

        // // systems
        let mut systems = array![
            spawn::TEST_CLASS_HASH,
            init::TEST_CLASS_HASH,
            build_base::TEST_CLASS_HASH,
            train_warrior::TEST_CLASS_HASH,
            take_warrior::TEST_CLASS_HASH,
            airdrop:: TEST_CLASS_HASH,
        ];

        let contract_addr = starknet::contract_address_const::<9>();
        starknet::testing::set_contract_address(contract_addr);
        starknet::testing::set_block_timestamp(3000);

        spawn_test_world(components, systems)
    }

    // -> (IWorldDispatcher, u64)
    fn create_start() -> (IWorldDispatcher, u64, ContractAddress) {
        let mut world = setup();
        let map_id: u64 = 1;

        // let mut calldata = Default::default();
        // let test_t: felt252 = 1; 
        // Serde::serialize(@test_t, ref calldata);
        let mut res = world.execute('init', array![]);
        let mut global_cfg = get!(world, (map_id), GlobalConfig);
        // global_cfg.MAX_MAP_X.print();
        // global_cfg.ADMIN.print();

        let player_name: felt252 = 1234.into();
        let mut spawn_player_calldata = array::ArrayTrait::<felt252>::new();
        // spawn_player_calldata.append(map_id.into());
        spawn_player_calldata.append(player_name);

        let mut result = world.execute('spawn', spawn_player_calldata);
        let player_address = serde::Serde::<ContractAddress>::deserialize(ref result)
            .expect('id des failed');

        player_address.print();
        let player = get!(world, (player_address), Player);
        // player.owner.print();
        // player.nick_name.print();
        // player.joined_time.print();

        (world, map_id, player_address)
    }

    fn create_base() -> (IWorldDispatcher,felt252, felt252) {
        let (world, game_id, player_address) = create_start();
        let map_id: felt252 = 1_u64.into();
        // works for map_id = 1
        let build_x: felt252 = 4;
        let build_y: felt252 = 1;

        world.execute('build_base', array![map_id, build_x, build_y]);
        world.execute('airdrop', array![map_id.into()]);

        (world, build_x, build_y)
    }

    fn train_soliders() -> (IWorldDispatcher, u64){
        let (world, build_x, build_y) = create_base();
        let map_id: felt252 = 1;
        let train_amount: u64 = 10;
        world.execute('train_warrior', array![map_id, train_amount.into()]);

        // claim all warrior aftet 10 x 10 sec
        starknet::testing::set_block_timestamp(3000 + 10 * train_amount);

        let mut result = world.execute('take_warrior', array![map_id]);
        let warrior_amount = serde::Serde::<u64>::deserialize(ref result)
            .expect('warror amount des failed');
        assert(warrior_amount == train_amount, 'warrior amount not match');

        (world, train_amount)
    }

    // let mut global_cfg = get!(world, (map_id).into(), (GlobalConfig));
    // let mut build_cfg = get!(world, (map_id).into(), (BuildConfig));
    // (world, player_map_id, player_address)

    #[test]
    #[available_gas(600000000)]
    // test spawn, build base, airdrop, train warrior
    fn test_start() {
        create_base();
    }
}
