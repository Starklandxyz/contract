#[system]
mod send_troop {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::warrior_config::WarriorConfig;
    use stark_land::components::land::Land;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::gold::Gold;
    use stark_land::components::troop::Troop;
    use stark_land::components::troop::TroopTrait;

    fn execute(
        ctx: Context,
        map_id: u64,
        amount: u64,
        troop_id: u64,
        from_x: u64,
        from_y: u64,
        to_x: u64,
        to_y: u64
    ) {
        let time_now: u64 = starknet::get_block_timestamp();

        let config = get!(ctx.world, map_id, WarriorConfig);
        assert(config.Train_Food != 0, 'config not ready');

        let land = get!(ctx.world, (map_id, from_x, from_y), Land);
        assert(land.owner == ctx.origin, 'not your land');

        let mut warrior = get!(ctx.world, (map_id, from_x, from_y), Warrior);
        assert(warrior.balance >= amount, 'warrior not enough');

        let mut troop = get!(ctx.world, (map_id, ctx.origin, troop_id), Troop);
        assert(troop.start_time == 0, 'troop not available');

        let dis = TroopTrait::distance(from_x, from_y, to_x, to_y);

        let food_need = config.Troop_Food * amount * dis;
        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        assert(food.balance >= food_need, 'food not enough');
        food.balance = food.balance - food_need;

        let gold_need = config.Troop_Gold * amount * dis;
        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        assert(gold.balance >= gold_need, 'gold not enough');
        gold.balance = gold.balance - gold_need;

        warrior.balance = warrior.balance - amount;
        troop.start_time = time_now;
        troop.from_x = from_x;
        troop.from_y = from_y;
        troop.to_x = to_x;
        troop.to_y = to_y;
        troop.balance = amount;

        set!(ctx.world, (food, gold, warrior, troop));
        return ();
    }
}
