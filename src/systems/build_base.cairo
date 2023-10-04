#[system]
mod build_base {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::player::Player;
    use stark_land::components::base::Base;

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        let player = get!(ctx.world, ctx.origin, (Player));
        assert(player.joined_time != 0, 'not joined!');
        assert(check_can_build(ctx,map_id,x,y), 'can not build here');

        set!(
            ctx.world, (Base { id: ctx.origin, map_id: map_id, x: x, y: y },)
        );
        return ();
    }

    //todo : 判断该地块是否可以修建基地
    fn check_can_build(ctx: Context, map_id: u64, x: u64, y: u64) -> bool {
        let base = get!(ctx.world, (ctx.origin, map_id), Base);
        //already have base in this map
        if (base.map_id != 0) {
            return false;
        }
        true
    }
}
