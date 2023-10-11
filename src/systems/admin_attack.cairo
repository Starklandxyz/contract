#[system]
mod admin_attack {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::build_config::BuildConfig;
    use stark_land::components::player::Player;
    use stark_land::components::base::Base;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        let mut land = get!(ctx.world, (map_id, x, y), Land);
        land.owner = ctx.origin;
        set!(ctx.world, (land));
        return ();
    }
}
