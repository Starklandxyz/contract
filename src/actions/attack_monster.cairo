#[system]
mod attack_monster {
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

    use debug::PrintTrait;

    fn execute(ctx: Context, map_id: u64, index: u64) {
        let time_now: u64 = starknet::get_block_timestamp();
        let mut troop = get!(ctx.world, (map_id, ctx.origin, index), Troop);
        assert(troop.start_time != 0, 'no troop');

        let land_barbarians = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);
        assert(land_barbarians > 100000, 'not monster land');

        let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);

        //kill all warriors
        user_warrior.balance = user_warrior.balance - troop.balance;
        troop.start_time = 0;

        //give stark pack
        let mut pack_amount: u64 = troop.balance / 100;
        pack_amount.print();
        let mut p: u64 = 0;
        if (pack_amount == 0) {
            p = troop.balance;
        } else {
            p = troop.balance - 100 * pack_amount;
        };
        let r1: u128 = random(troop.to_x * 9 + troop.to_y * 2 + map_id * 7 + time_now) % 100
            + 1; // 1-100
        let p: u128 = p.into();
        r1.print();
        p.print();

        if (r1 <= p) {
            pack_amount += 1;
        }

        pack_amount.print();
        let mut luck_pack = get!(ctx.world, (map_id, ctx.origin), LuckyPack);
        luck_pack.balance = luck_pack.balance + pack_amount;

        set!(ctx.world, (troop, user_warrior, luck_pack));
        return ();
    }
}
