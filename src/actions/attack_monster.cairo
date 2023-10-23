use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, index: u64);
}

// dojo decorator
#[dojo::contract]
mod attack_monster {
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

    use debug::PrintTrait;


    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64, index: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            let mut troop = get!(world, (map_id, origin, index), Troop);
            assert(troop.start_time != 0, 'no troop');

            let land_barbarians = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);
            assert(land_barbarians > 100000, 'not monster land');

            let mut user_warrior = get!(world, (map_id, origin), UserWarrior);

            //kill all warriors
            user_warrior.balance = user_warrior.balance - troop.balance;
            troop.start_time = 0;

            //give stark pack
            let mut pack_amount: u64 = troop.balance / 100;
            pack_amount.print();
            let mut p: u64 = 0;
            if (pack_amount == 0) {
                p = troop.balance;
            } else {
                p = troop.balance - 100 * pack_amount;
            };
            let r1: u128 = random(troop.to_x * 9 + troop.to_y * 2 + map_id * 7 + time_now) % 100
                + 1; // 1-100
            let p: u128 = p.into();
            r1.print();
            p.print();

            if (r1 <= p) {
                pack_amount += 1;
            }

            pack_amount.print();
            let mut luck_pack = get!(world, (map_id, origin), LuckyPack);
            luck_pack.balance = luck_pack.balance + pack_amount;

            set!(world, (troop, user_warrior, luck_pack));
            return ();
        }
    }
}
