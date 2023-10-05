#[system]
mod build_base {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;


    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::player::Player;
    use stark_land::components::base::Base;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        let player = get!(ctx.world, ctx.origin, (Player));
        assert(player.joined_time != 0, 'not joined!');
        assert(check_can_build_base(ctx, map_id, x, y), 'can not build here');

        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x == 0 && base.y == 0, 'you have base');
        set!(ctx.world, (Base { map_id: map_id, id: ctx.origin, x: x, y: y },));

        set!(
            ctx.world,
            (Land { map_id: map_id, x: x, y: y, owner: ctx.origin, building: 1, level: 1 },)
        );
        set!(
            ctx.world,
            (Land { map_id: map_id, x: x, y: y + 1, owner: ctx.origin, building: 1, level: 1 },)
        );
        set!(
            ctx.world,
            (Land { map_id: map_id, x: x + 1, y: y, owner: ctx.origin, building: 1, level: 1 },)
        );
        set!(
            ctx.world,
            (Land { map_id: map_id, x: x + 1, y: y + 1, owner: ctx.origin, building: 1, level: 1 },)
        );
        return ();
    }

    //todo : 判断该地块是否可以修建基地
    fn check_can_build_base(ctx: Context, map_id: u64, x: u64, y: u64) -> bool {
        let p: bool = check_single_land_buildable(ctx, map_id, x, y);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(ctx, map_id, x + 1, y);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(ctx, map_id, x, y + 1);
        if (!p) {
            return false;
        }
        let p = check_single_land_buildable(ctx, map_id, x + 1, y + 1);
        if (!p) {
            return false;
        }
        true
    }

    fn check_single_land_buildable(ctx: Context, map_id: u64, x: u64, y: u64) -> bool {
        let config = get!(ctx.world, map_id, (GlobalConfig));
        if (config.MAX_MAP_X == 0) {
            return false;
        }
        //超过地图范围
        if (x > config.MAX_MAP_X || y > config.MAX_MAP_Y || x == 0 || y == 0) {
            return false;
        }
        //该地块是否有其他建筑，是否可以修建
        let land = get!(ctx.world, (map_id, x, y), Land);
        if (land.building != 0) {
            return false;
        }
        //是否是不可建设用地
        if (LandTrait::land_property(map_id, x, y) < 6) {
            return false;
        }
        true
    }
}
