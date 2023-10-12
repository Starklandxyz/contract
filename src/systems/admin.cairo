#[system]
mod admin {
    use dojo::world::Context;

    use stark_land::components::gold::Gold;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::base::Base;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::airdrop::Airdrop;
    use stark_land::components::airdrop_config::AirdropConfig;
    use stark_land::components::troop::Troop;
    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;
    use stark_land::components::build_config::BuildConfig;

    fn execute(ctx: Context, map_id: u64) {
        let base = get!(ctx.world,(map_id,ctx.origin),Base);
        let mut warrior = get!(ctx.world, (map_id, base.x, base.y), Warrior);
        warrior.balance += 100;

        let mut user_warrior  =get!(ctx.world,(map_id,ctx.origin),UserWarrior);
        user_warrior.balance += 100;

        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        gold.balance = gold.balance + 1000_000_000;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        iron.balance = iron.balance + 1000_000_000;

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        food.balance = food.balance + 10000_000_000;

        set!(ctx.world, (user_warrior, warrior, gold, iron, food,));
        return ();
    }
}