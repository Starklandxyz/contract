use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, index: u64, x: u64, y: u64);
}

// dojo decorator
#[dojo::contract]
mod claim_airdrop {
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::gold::Gold;
    use stark_land::models::food::Food;
    use stark_land::models::iron::Iron;
    use stark_land::models::hbase::HBase;
    use stark_land::models::user_warrior::UserWarrior;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::airdrop::Airdrop;
    use stark_land::models::airdrop_config::AirdropConfig;
    use stark_land::models::troop::Troop;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::build_config::BuildConfig;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState,  map_id: u64, index: u64, x: u64, y: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let mut airdrop = get!(world, (map_id, origin, index), Airdrop);
            assert(!airdrop.claimed, 'claimed');

            let airdrop_config = get!(world, (map_id, index), AirdropConfig);

            airdrop.claimed = true;

            let reward_warrior: u64 = airdrop_config.reward_warrior;
            let reward_food: u64 = airdrop_config.reward_food;
            let reward_gold: u64 = airdrop_config.reward_gold;
            let reward_iron: u64 = airdrop_config.reward_iron;

            let base = get!(world, (map_id, origin), HBase);
            let mut user_warrior = get!(world, (map_id, origin), UserWarrior);
            //修建基地
            if (index == 1) {
                assert(base.x != 0, 'no base');
            } //拥有30个士兵
            else if (index == 2) {
                assert(user_warrior.balance >= 30, 'no enough warrior');
            } //拥有1个Troop
            else if (index == 3) {
                let troop = get!(world, (map_id, origin, 1), Troop);
                assert(troop.from_x != 0 && troop.from_y != 0, 'no troop');
            } //拥有第一个land
            else if (index == 4) {
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not your land');
                let config = get!(world, (map_id), BuildConfig);
                assert(land.building != config.Build_Type_Base, 'not land');
            } //拥有第一个farmland
            else if (index == 5) {
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not your land');
                let config = get!(world, (map_id), BuildConfig);
                assert(land.building == config.Build_Type_Farmland, 'not farmland');
            } //拥有第一个goldmine
            else if (index == 6) {
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not your land');
                let config = get!(world, (map_id), BuildConfig);
                assert(land.building == config.Build_Type_GoldMine, 'not goldmine');
            } //拥有第一个ironmine
            else if (index == 7) {
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not your land');
                let config = get!(world, (map_id), BuildConfig);
                assert(land.building == config.Build_Type_IronMine, 'not ironmine');
            } //拥有第一个camp
            else if (index == 8) {
                let land = get!(world, (map_id, x, y), Land);
                assert(land.owner == origin, 'not your land');
                let config = get!(world, (map_id), BuildConfig);
                assert(land.building == config.Build_Type_Camp, 'not camp');
            }

            user_warrior.balance += reward_warrior;

            let mut warrior = get!(world, (map_id, base.x, base.y), Warrior);
            warrior.balance += reward_warrior;

            let mut gold = get!(world, (map_id, origin), Gold);
            gold.balance = gold.balance + reward_gold;

            let mut iron = get!(world, (map_id, origin), Iron);
            iron.balance = iron.balance + reward_iron;

            let mut food = get!(world, (map_id, origin), Food);
            food.balance = food.balance + reward_food;

            set!(world, (user_warrior, warrior, gold, iron, food, airdrop));
            return ();
        }
    }
}
