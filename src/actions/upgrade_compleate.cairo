#[system]
mod upgrade_compleate {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::build_config::BuildConfig;
    use stark_land::components::build_price::BuildPrice;
    use stark_land::components::player::Player;

    use stark_land::components::base::Base;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
 
    use stark_land::components::upgrade_cost::UpgradeCost;

    fn execute(ctx: Context, map_id: u64, x: u64, y: u64) {
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x != 0 && base.y != 0, 'you have no base');        
        let mut upgrade_cost = get!(ctx.world,(map_id,x, y),UpgradeCost);
        assert(upgrade_cost.start_time != 0, 'you have not upgrade');
         
        // 判断建筑物是否升级完毕
        let time_now: u64 = starknet::get_block_timestamp();
        assert(time_now >= upgrade_cost.end_time, 'building are upgrading');
        assert( !upgrade_cost.claimed, 'targrt_level claimed'); // 如果上次升级的级别已经 claim ,则 X

        let mut land = get!(ctx.world, (map_id, x, y), Land);
        land.level = upgrade_cost.target_level;
        upgrade_cost.claimed = true;
        
        set!(ctx.world, (land, upgrade_cost));
        return ();
    }
}