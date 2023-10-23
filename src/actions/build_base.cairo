use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, x: u64, y: u64);
}

// dojo decorator
#[dojo::contract]
mod build_base {
    use starknet::{ContractAddress, get_caller_address};
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use stark_land::models::global_config::GlobalConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::player::Player;
    use stark_land::models::hbase::HBase;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::land_mining::LandMining;
    use super::IActions;

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

            let player = get!(world, origin, (Player));
            assert(player.joined_time != 0, 'not joined!');
            assert(check_can_build_base(self, map_id, x, y), 'can not build here');

            let base = get!(world, (map_id, origin), HBase);
            assert(base.x == 0 && base.y == 0, 'you have base');
            set!(world, (HBase { map_id: map_id, owner: origin, x: x, y: y },));

            set!(
                world, (Land { map_id: map_id, x: x, y: y, owner: origin, building: 1, level: 1 },)
            );
            set!(
                world,
                (Land { map_id: map_id, x: x, y: y + 1, owner: origin, building: 1, level: 1 },)
            );
            set!(
                world,
                (Land { map_id: map_id, x: x + 1, y: y, owner: origin, building: 1, level: 1 },)
            );
            set!(
                world,
                (Land { map_id: map_id, x: x + 1, y: y + 1, owner: origin, building: 1, level: 1 },)
            );

            // set!(ctx.world, (LandMining { map_id: map_id, x: x, y: y, start_time: time_now },));
            let mut land_mining = get!(world, (map_id, x, y), LandMining);
            land_mining.start_time = time_now;
            set!(world, (land_mining));
            return ();
        }
    }

    //todo : 判断该地块是否可以修建基地
    fn check_can_build_base(self: @ContractState, map_id: u64, x: u64, y: u64) -> bool {
        let p: bool = check_single_land_buildable(self, map_id, x, y);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(self, map_id, x + 1, y);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(self, map_id, x, y + 1);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(self, map_id, x + 1, y + 1);
        if (!p) {
            return false;
        }
        true
    }

    fn check_single_land_buildable(self: @ContractState, map_id: u64, x: u64, y: u64) -> bool {
        let world = self.world_dispatcher.read();
        let config = get!(world, map_id, (GlobalConfig));
        let build_config = get!(world, map_id, BuildConfig);
        if (config.MAX_MAP_X == 0) {
            return false;
        }
        //超过地图范围
        if (x > config.MAX_MAP_X || y > config.MAX_MAP_Y || x == 0 || y == 0) {
            return false;
        }
        //该地块是否有其他建筑，是否可以修建
        let land = get!(world, (map_id, x, y), Land);
        if (land.building != 0) {
            return false;
        }
        //是否是不可建设用地
        if (LandTrait::land_property(map_id, x, y) < build_config.Land_None) {
            return false;
        }
        true
    }
}
