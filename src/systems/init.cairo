#[system]
mod init {
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::warrior_config::WarriorConfig;
    // use stark_land::constants::MAX_MAP_X;
    // use stark_land::constants::MAX_MAP_Y;

    #[event]
    use stark_land::events::inited::{Event, MapInited};

    fn execute(ctx: Context) {
        let max_map_x: u64 = 100;
        let max_map_y: u64 = 100;

        set!(ctx.world, (GlobalConfig { map_id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y },));
        set!(
            ctx.world,
            (
                WarriorConfig {
                    map_id: 1,
                    Train_Food: 10,
                    Train_Gold: 10,
                    Train_Iron: 0,
                    Train_Time: 10,
                    Troop_Food: 10,
                    Troop_Gold: 0,
                    Troop_Speed: 10
                },
            )
        );

        emit!(ctx.world, MapInited { map_id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y });

        return ();
    }
}
