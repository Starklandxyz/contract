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
    use stark_land::components::airdrop_config::AirdropConfig;
    use stark_land::components::troop::Troop;
    use stark_land::components::land::Land;
    use stark_land::components::build_config::BuildConfig;

    fn execute(ctx: Context, map_id: u64, index: u64, x: u64, y: u64) {
        let mut airdrop = get!(ctx.world, (map_id, ctx.origin, index), Airdrop);
        assert(!airdrop.claimed, 'claimed');

        let airdrop_config = get!(ctx.world, (map_id, index), AirdropConfig);

        airdrop.claimed = true;

        let reward_warrior: u64 = airdrop_config.reward_warrior;
        let reward_food: u64 = airdrop_config.reward_food;
        let reward_gold: u64 = airdrop_config.reward_gold;
        let reward_iron: u64 = airdrop_config.reward_iron;

        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);
        //修建基地
        if (index == 1) {
            assert(base.x != 0, 'no base');
        } //拥有15个士兵
        else if (index == 2) {
            assert(user_warrior.balance >= 15, 'no enough warrior');
        } //拥有1个Troop
        else if (index == 3) {
            let troop1 = get!(ctx.world, (map_id, ctx.origin, 1), Troop);
            let troop2 = get!(ctx.world, (map_id, ctx.origin, 2), Troop);
            let troop3 = get!(ctx.world, (map_id, ctx.origin, 3), Troop);
            if (troop1.start_time + troop2.start_time + troop3.start_time == 0) {
                panic_with_felt252('no troop');
            }
        } //拥有第一个farmland
        else if (index == 4) {
            let land = get!(ctx.world, (map_id, x, y), Land);
            assert(land.owner == ctx.origin, 'not your land');
            let config = get!(ctx.world, (map_id), BuildConfig);
            assert(land.building == config.Build_Type_Farmland, 'not farmland');
        } //拥有第一个goldmine
        else if (index == 5) {
            let land = get!(ctx.world, (map_id, x, y), Land);
            assert(land.owner == ctx.origin, 'not your land');
            let config = get!(ctx.world, (map_id), BuildConfig);
            assert(land.building == config.Build_Type_GoldMine, 'not goldmine');
        } //拥有第一个ironmine
        else if (index == 6) {
            let land = get!(ctx.world, (map_id, x, y), Land);
            assert(land.owner == ctx.origin, 'not your land');
            let config = get!(ctx.world, (map_id), BuildConfig);
            assert(land.building == config.Build_Type_IronMine, 'not ironmine');
        } //拥有第一个camp
        else if (index == 7) {
            let land = get!(ctx.world, (map_id, x, y), Land);
            assert(land.owner == ctx.origin, 'not your land');
            let config = get!(ctx.world, (map_id), BuildConfig);
            assert(land.building == config.Build_Type_Camp, 'not camp');
        }

        user_warrior.balance += reward_warrior;

        let mut warrior = get!(ctx.world, (map_id, base.x, base.y), Warrior);
        warrior.balance += reward_warrior;

        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        gold.balance = gold.balance + reward_gold;

        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        iron.balance = iron.balance + reward_iron;

        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        food.balance = food.balance + reward_food;

        set!(ctx.world, (user_warrior, warrior, gold, iron, food, airdrop));
        return ();
    }
}
