#[system]
mod retreat_troop {
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
        assert(!troop.retreat, 'is retreating');

        troop.retreat = true;

        let total_time = troop.distance * config.Troop_Speed;
        //at the end of the troop
        if(time_now - troop.start_time > total_time){
            troop.start_time = time_now;
        }else{
            troop.start_time = time_now - total_time + time_now - troop.start_time;
        }

        let from_x = troop.from_x;
        let from_y = troop.from_y;

        troop.from_x = troop.to_x;
        troop.from_y = troop.to_y;
        troop.to_x = from_x;
        troop.to_y = from_y;

        set!(ctx.world, (troop));
        return ();
    }
}