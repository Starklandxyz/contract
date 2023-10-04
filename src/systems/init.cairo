#[system]
mod init {
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    // use stark_land::constants::MAX_MAP_X;
    // use stark_land::constants::MAX_MAP_Y;

    #[event]
    use stark_land::events::inited::{Event, MapInited};

    fn execute(ctx: Context) {

        let max_map_x: u64 = 100;
        let max_map_y: u64 = 100;

        set!(
            ctx.world,
            (
                GlobalConfig { id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y },
            )
        );

        emit!(ctx.world, MapInited { id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y });

        return ();
    }
}