use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, x: u64, y: u64);
}

// dojo decorator
#[dojo::contract]
mod upgrade_compleate {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::build_price::BuildPrice;
    use stark_land::models::player::Player;
    use stark_land::models::hbase::HBase;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::upgrade_cost::UpgradeCost;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn execute(self: @ContractState, map_id: u64, x: u64, y: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();

            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();
            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0 && base.y != 0, 'you have no base');
            let mut upgrade_cost = get!(world, (map_id, x, y), UpgradeCost);
            assert(upgrade_cost.start_time != 0, 'you have not upgrade');

            // 判断建筑物是否升级完毕
            let time_now: u64 = starknet::get_block_timestamp();
            assert(time_now >= upgrade_cost.end_time, 'building are upgrading');
            assert(
                !upgrade_cost.claimed, 'targrt_level claimed'
            ); // 如果上次升级的级别已经 claim ,则 X

            let mut land = get!(world, (map_id, x, y), Land);
            land.level = upgrade_cost.target_level;
            upgrade_cost.claimed = true;

            set!(world, (land, upgrade_cost));
            return ();
        }
    }
}
