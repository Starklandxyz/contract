#[system]
mod airdrop {
    use dojo::world::Context;

    use stark_land::components::gold::Gold;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::base::Base;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::airdrop::Airdrop;

    fn execute(ctx: Context, map_id: u64) {
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        assert(base.x != 0, 'no base');

        let mut airdrop = get!(ctx.world, (ctx.origin), Airdrop);
        assert(!airdrop.claimed, 'claimed');

        airdrop.claimed = true;

        let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);
        user_warrior.balance += 3;

        let mut warrior = get!(ctx.world, (map_id, base.x, base.y), Warrior);
        warrior.balance += 3;

        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        gold.balance = gold.balance + 1000 * 1_000_000;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        iron.balance = iron.balance + 1000 * 1_000_000;

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        food.balance = food.balance + 8000 * 1_000_000;

        set!(ctx.world, (user_warrior, warrior, gold, iron, food, airdrop));
        return ();
    }
}
