#[system]
mod enter_land {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::warrior_config::WarriorConfig;
    use stark_land::components::land::Land;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::base::Base;
    use stark_land::components::troop::Troop;
    use stark_land::components::troop::TroopTrait;

    fn execute(
        ctx: Context,
        map_id: u64,
        troop_index: u64,
    ) {
        let time_now: u64 = starknet::get_block_timestamp();

        let config = get!(ctx.world, map_id, WarriorConfig);
        assert(config.Train_Food != 0, 'config not ready');

        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x!=0, 'no base');

        let mut troop = get!(ctx.world,(map_id,ctx.origin,troop_index),Troop);
        assert(troop.start_time!=0, 'no troop');
        
        let total_time = troop.distance * config.Troop_Speed;
        assert((time_now - troop.start_time) > total_time, 'not reached, can not fight');

        troop.start_time = 0;
        troop.retreat = false;

        let land = get!(ctx.world,(map_id,troop.to_x,troop.to_y),Land);
        assert(land.owner==ctx.origin, 'not your land');

        let mut warrior = get!(ctx.world,(map_id,troop.to_x,troop.to_y),Warrior);
        warrior.balance = warrior.balance + troop.balance;

        set!(ctx.world, (troop,warrior));
        return ();
    }
}