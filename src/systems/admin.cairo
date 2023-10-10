#[system]
mod admin {
    use dojo::world::Context;

    use stark_land::components::gold::Gold;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;

    #[event]
    use stark_land::events::inited::{Event, MapInited};

    fn execute(ctx: Context, map_id: u64) {
        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        gold.balance = gold.balance + 1000*1_000_000;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        iron.balance = iron.balance + 1000*1_000_000;

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        food.balance = food.balance + 1000*1_000_000;

        set!(ctx.world, (gold, iron, food));
        return ();
    }
}
