#[system]
mod open_pack {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
    use stark_land::components::troop::Troop;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::utils::random::random;
    use stark_land::components::lucky_pack::LuckyPack;
    use stark_land::components::reward_point::RewardPoint;

    use debug::PrintTrait;

    fn execute(ctx: Context, map_id: u64, amount: u64) {
        let time_now: u64 = starknet::get_block_timestamp();
        let mut lucky_pack = get!(ctx.world, (map_id, ctx.origin), LuckyPack);
        assert(lucky_pack.balance >= amount, 'not enough');

        lucky_pack.balance =  lucky_pack.balance - amount;

        //1box : 100-200 points
        let r1: u128 = random(amount * 9 + time_now * 2 + map_id * 7) % 10000 + 10000; // 100-200
        let r2:u64 = r1.try_into().unwrap();

        let total = r2 * amount / 100;

        let mut reward_point = get!(ctx.world,(map_id,ctx.origin),RewardPoint);
        reward_point.balance = reward_point.balance + total;

        set!(ctx.world, (lucky_pack,reward_point));
        return ();
    }
}
