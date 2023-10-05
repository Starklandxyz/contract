#[system]
mod train_warrior {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::warrior_config::WarriorConfig;
    use stark_land::components::training::Training;
    use stark_land::components::training::TrainImpl;
    use stark_land::components::base::Base;
    use stark_land::components::food::Food;
    use stark_land::components::iron::Iron;
    use stark_land::components::gold::Gold;

    fn execute(ctx: Context, map_id: u64, amount: u64) {
        let time_now: u64 = starknet::get_block_timestamp();

        let base = get!(ctx.world, ctx.origin, (Base));
        assert(base.x != 0 && base.y != 0, 'you not joined!');

        let config = get!(ctx.world, map_id, WarriorConfig);
        assert(config.Train_Food != 0, 'config not ready');

        let mut training = get!(ctx.world, (map_id, ctx.origin), Training);
        assert(time_now > training.end_time(config.Train_Time), 'train not finish');

        let food_need = config.Train_Food * amount;
        let mut food = get!(ctx.world, (map_id, ctx.origin), Food);
        assert(food.balance >= food_need, 'food not enough');
        food.balance = food.balance - food_need;

        let iron_need = config.Train_Gold * amount;
        let mut iron = get!(ctx.world, (map_id, ctx.origin), Iron);
        assert(iron.balance >= iron_need, 'iron not enough');
        iron.balance = iron.balance - iron_need;

        let gold_need = config.Train_Iron * amount;
        let mut gold = get!(ctx.world, (map_id, ctx.origin), Gold);
        assert(gold.balance >= gold_need, 'gold not enough');
        gold.balance = gold.balance - gold_need;

        training.start_time = time_now;
        training.total = amount;

        set!(ctx.world, (food, iron, gold, training));
        return ();
    }
}
