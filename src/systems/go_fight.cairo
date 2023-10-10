#[system]
mod go_fight {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::base::Base;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::warrior_config::WarriorConfig;
    use stark_land::components::build_config::BuildConfig;


    use stark_land::components::troop::Troop;
    use stark_land::components::troop::TroopImpl;

    use stark_land::components::land::Land;
    use stark_land::components::land::LandTrait;

    use stark_land::utils::random::random;
    use starknet::ContractAddress;

    fn execute(ctx: Context, map_id: u64, troop_index: u64) {
        // 根据MapId 获取地址，已经获取到对方玩家信息、计算双方人数、时间复杂度最少

        let time_now: u64 = starknet::get_block_timestamp();

        // 根据 troop_index 获取我方派出的兵团
        let mut troop = get!(ctx.world, (map_id, ctx.origin, troop_index), Troop);
        assert(troop.start_time != 0, 'no troop');

        // 判断是否到达目的地
        // 速度 时间 距离  实际距离 = 实际速度 * 时间
        let config = get!(ctx.world, map_id, WarriorConfig);
        let total_time = troop.distance * config.Troop_Speed;
        //at the end of the troop

        // 没到达
        assert((time_now - troop.start_time) > total_time, 'not reached, can not fight');

        let mut land = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Land);

        let mut x: u64 = troop.balance;
        let mut y: u64 = 0;

        let y_address: ContractAddress = land.owner;

        let mut isLand_None = 0;

        let owner = land.owner;

        if (!owner.is_zero()) {
            assert(land.owner == ctx.origin, 'your land can not fight');

            let mut y_warrior = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Warrior);

            // 获取士兵
            y = y_warrior.balance;
        } else {
            // 如果是无主之地，获取野蛮人数量
            let barbarians: u64 = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);
            y = barbarians;
            isLand_None = 1
        }

        // x 人数、y 人数，y 实际攻击力是 y * 1.3、
        // 胜率是 x = x / 1.3*y + x , x 损失人数是 [0，（1 -（ x / 1.3*y + x]  的随机值 * x 
        // 胜率是 y = 1.3*y / 1.3*y + x , x 损失人数是 [0,（1 -（ y / 1.3*y + x）* y]  的随机值 * y
        // 胜率高 伤亡人数少

        // 扩大 100 倍
        let actual_attack_power_y: u64 = y * 130; // 扩大 100 倍

        let win_rate_x: u64 = x
            * 10000
            / (actual_attack_power_y
                + x * 100); // x 放大 10000 和胜负率.类似、结果是 0 - 100

        let r1: u128 = random(x * 99 + y + map_id * 17) + 1_u128;

        let r2: u64 = r1.try_into().unwrap();

        let random_loss_x: u64 = r2 % (100 - win_rate_x); // 1-100

        let win_rate_y: u64 = actual_attack_power_y * 10000 / (actual_attack_power_y + x * 100);

        let random_loss_y: u64 = r2 % (100
            - win_rate_y); // 1-100 \ 因为胜率越高，伤亡越少，即取余数的 被余数 越小，结果也偏小

        // 更新双方人员数据 

        x = x - random_loss_x;

        y = y - random_loss_y;

        // 一轮结束，谁剩下人数多就赢

        if (x > y) {
            land.owner = troop.owner;
            let mut warrior = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Warrior);
            warrior.balance = x;

            let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);
            let user_balance: u64 = user_warrior.balance;
            user_warrior.balance = user_balance - random_loss_x;

            // 更新土地 士兵信息
            set!(ctx.world, (warrior, land, user_warrior));

            if (isLand_None == 1) {// 如果是无主指定，更新owner \ 士兵 已经完成

            } else {
                // 敌人回家、更新敌人基地人数、更新敌人兵团人数
                let base = get!(ctx.world, (map_id, y_address), Base);

                let mut y_warrior = get!(ctx.world, (map_id, base.x, base.y), Warrior);

                y_warrior.balance = y_warrior.balance + y;

                let mut user_warrior = get!(ctx.world, (map_id, y_address), UserWarrior);

                user_warrior.balance = user_warrior.balance - random_loss_y;

                set!(ctx.world, (y_warrior, user_warrior));
            }
        } else {
            // 人数加回基地
            let mut warrior = get!(ctx.world, (map_id, troop.from_x, troop.from_y), Warrior);
            // 返回人数
            warrior.balance = warrior.balance + x;

            let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);
            // 更新人数、扣减伤亡人数
            user_warrior.balance = user_warrior.balance - random_loss_x;

            set!(ctx.world, (warrior, user_warrior));

            // 更新 敌方数据
            let mut y_warrior = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Warrior);

            // 剩下的人数更新
            y_warrior.balance = y;

            let mut y_user_warrior = get!(ctx.world, (map_id, y_address), UserWarrior);

            y_user_warrior.balance = y_user_warrior.balance - random_loss_y;

            set!(ctx.world, (y_warrior, y_user_warrior));
        }

        return ();
    }
}
