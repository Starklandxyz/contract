use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64);
}

// dojo decorator
#[dojo::contract]
mod admin {
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
        fn execute(self: @ContractState, map_id: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            let base = get!(world, (map_id, origin), HBase);
            let mut warrior = get!(world, (map_id, base.x, base.y), Warrior);
            warrior.balance += 100;

            let mut user_warrior = get!(world, (map_id, origin), UserWarrior);
            user_warrior.balance += 100;

            let mut gold = get!(world, (map_id, origin), Gold);
            gold.balance = gold.balance + 1000_000_000;

            let mut iron = get!(world, (map_id, origin), Iron);
            iron.balance = iron.balance + 1000_000_000;

            let mut food = get!(world, (map_id, origin), Food);
            food.balance = food.balance + 10000_000_000;

            set!(world, (user_warrior, warrior, gold, iron, food,));
            return ();
        }
    }
}
