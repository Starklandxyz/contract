#[system]
mod take_warrior {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::training::Training;
    use stark_land::components::training::TrainImpl;

    use stark_land::components::base::Base;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::warrior_config::WarriorConfig;

    fn execute(ctx: Context, map_id: u64) -> u64 {
        let time_now: u64 = starknet::get_block_timestamp();

        let mut training = get!(ctx.world, (map_id, ctx.origin), Training);

        let config = get!(ctx.world, map_id, WarriorConfig);
        assert(config.Train_Food != 0, 'config not ready');

        let amount = training.can_take_out_amount(config.Train_Time, time_now);
        assert(amount != 0, 'not claimable');

        training.out = training.out + amount;

        let base = get!(ctx.world,(map_id,ctx.origin),Base);
        let mut warrior = get!(ctx.world, (map_id, base.x, base.y), Warrior);
        warrior.balance = warrior.balance + amount;

        let mut user_warrior = get!(ctx.world,(map_id,ctx.origin),UserWarrior);
        user_warrior.balance = user_warrior.balance + amount;

        set!(ctx.world, (training, warrior,user_warrior));
        return user_warrior.balance;
    }
}
