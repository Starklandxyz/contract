#[system]
mod airdrop {
    use dojo::world::Context;

    use stark_land::components::gold::Gold;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::player::Player;
    use stark_land::components::airdrop::Airdrop;

    fn execute(ctx: Context, map_id: u64) {
        let player = get!(ctx.world,(ctx.origin),Player);
        assert(player.joined_time!=0, 'no player');

        let mut airdrop = get!(ctx.world,(ctx.origin),Airdrop);
        assert(!airdrop.claimed, 'claimed');

        airdrop.claimed = true;

        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        gold.balance = gold.balance + 100*1_000_000;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        iron.balance = iron.balance + 100*1_000_000;

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        food.balance = food.balance + 100*1_000_000;

        set!(ctx.world, (gold, iron, food,airdrop));
        return ();
    }
}
