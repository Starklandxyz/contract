use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, amount: u64);
}

// dojo decorator
#[dojo::contract]
mod open_pack {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::troop::Troop;
    use stark_land::models::user_warrior::UserWarrior;
    use stark_land::utils::random::random;
    use stark_land::models::lucky_pack::LuckyPack;
    use stark_land::models::reward_point::RewardPoint;

    use debug::PrintTrait;


    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64, amount: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            let mut lucky_pack = get!(world, (map_id, origin), LuckyPack);
            assert(lucky_pack.balance >= amount, 'not enough');

            lucky_pack.balance = lucky_pack.balance - amount;

            //1box : 100-200 points
            let r1: u128 = random(amount * 9 + time_now * 2 + map_id * 7) % 10000
                + 10000; // 100-200
            let r2: u64 = r1.try_into().unwrap();

            let total = r2 * amount / 100;

            let mut reward_point = get!(world, (map_id, origin), RewardPoint);
            reward_point.balance = reward_point.balance + total;

            set!(world, (lucky_pack, reward_point));
            return ();
        }
    }
}
