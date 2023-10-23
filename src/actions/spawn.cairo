use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, nick_name: felt252);
}

// dojo decorator
#[dojo::contract]
mod spawn {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use stark_land::models::player::Player;
    use stark_land::models::eth::ETH;
    use super::IActions;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, nick_name: felt252) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let player = get!(world, origin, (Player));
            assert(player.joined_time == 0, 'you have joined!');

            set!(
                world,
                (
                    Player {
                        owner: origin, // 玩家钱包地址
                        nick_name: nick_name,
                        joined_time: time_now
                    },
                )
            );
            set!(world, (ETH { owner: origin, balance: 500_000_000_000_000_000 }));
        }
    }
}
