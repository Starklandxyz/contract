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

    use stark_land::components::land_owner::LandOwner;
    use stark_land::components::land_owner::LandOwnerTrait;

    use stark_land::utils::random::random;
    use starknet::ContractAddress;

    use debug::PrintTrait;

    fn execute(ctx: Context, map_id: u64, troop_index: u64) {
        // 根据MapId 获取地址，已经获取到对方玩家信息、计算双方人数、时间复杂度最少

        let time_now: u64 = starknet::get_block_timestamp();

        let mut land_owner = get!(ctx.world, (map_id, ctx.origin), LandOwner);
        let base = get!(ctx.world, (map_id, ctx.origin), Base);
        let land = get!(ctx.world, (map_id, base.x, base.y), Land);
        let maxLand = LandOwnerTrait::land_max_amount(land.level);
        assert(land_owner.total < maxLand, 'exceed max land');

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

        assert(troop.balance > 0, 'no balance, can not fight');

        let mut land = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Land);

        let mut x: u64 = troop.balance * 100;
        let mut y: u64 = 0;

        let mut total_y: u64 = 0;

        let y_address: ContractAddress = land.owner;

        let mut isLand_None: u64 = 0;

        let owner = land.owner;

        let mut y_warrior = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Warrior);

        if (!owner.is_zero()) {
            assert(land.owner != ctx.origin, 'your land can not fight');
            // 获取士兵 可能有士兵 可能没士兵
            y = y_warrior.balance * 100;
            isLand_None = 1;

            let barbarians: u64 = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);

            total_y = y + barbarians * 100;
           
        } else {
            // 如果是无主之地，获取野蛮人数量
            let barbarians: u64 = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);
            isLand_None = 0;

            total_y = barbarians * 100;
        }

        // x 人数、y 人数，y 实际攻击力是 y * 1.3、
        // 胜率是 x = x / 1.3*y + x , x 损失人数是 [0，（1 -（ x / 1.3*y + x]  的随机值 * x
        // 胜率是 y = 1.3*y / 1.3*y + x , x 损失人数是 [0,（1 -（ y / 1.3*y + x）* y]  的随机值 * y
        // 胜率高 伤亡人数少

        let y_power: u64 = total_y * 130 / 100;

        let xr1: u128 = random(x * 99 + y + map_id * 17) % 10_u128 + 1_u128;
        let xr2: u64 = xr1.try_into().unwrap();

        let mut random_loss_x: u64 = x * (y_power + xr2) * 100 / (x + y_power + xr2) / 100;

        let mut random_loss_y: u64 = total_y * (x + xr2) * 100 / (x + y_power + xr2) / 100;

        x.print();
        total_y.print();

        random_loss_x.print();
        random_loss_y.print();

        x = x / 100;
        total_y = total_y / 100;

        random_loss_x = random_loss_x / 100;
        random_loss_y = random_loss_y / 100;

        if (random_loss_x <= 0) {
            random_loss_x = 1;
        }

        if (random_loss_y <= 0) {
            random_loss_y = 1;
        }

        if (random_loss_x >= x) {
            random_loss_x = x;
        }

        if (random_loss_y >= total_y) {
            random_loss_y = total_y;
        }

        if (total_y / x >= 3) {
            random_loss_x = x;
        }

        if (x / total_y >= 3) {
            random_loss_y = total_y;
        }

        x = x - random_loss_x;

        total_y = total_y - random_loss_y;

        troop.balance = x;

        troop.balance.print();

        // 一轮结束，谁剩下人数多就赢

        let win: u64 = 1;
        let lost: u64 = 2;

        let youzhu = 111;
        //攻击方胜利
        if (x > total_y) {
            win.print();

            land.owner = troop.owner;
            let mut warrior = get!(ctx.world, (map_id, troop.to_x, troop.to_y), Warrior);

            warrior.balance = x;

            warrior.balance.print();

            //删除兵团
            troop.start_time = 0;

            let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);
            user_warrior.balance = user_warrior.balance - random_loss_x;
            land_owner.total = land_owner.total + 1;
            // 更新土地 士兵信息
            set!(ctx.world, (warrior, land_owner, land, user_warrior, troop));

            if (isLand_None >= 1) {
                youzhu.print();

                if(y <= 0){
                    return ();
                }

                // 有主之地 \  初始人数
                y = y / 100;

                // 敌人回家、更新敌人基地人数、更新敌人兵团人数
                if( random_loss_y >= y){
                    random_loss_y = y;
                }

                y = y - random_loss_y;

                // 更新当前余额
                y_warrior.balance = y_warrior.balance + y;

                let mut y_user_warrior = get!(ctx.world, (map_id, y_address), UserWarrior);
                let mut y_user_land = get!(ctx.world, (map_id, y_address), LandOwner);

                y_user_warrior.balance = y_user_warrior.balance - random_loss_y;
                y_user_land.total = y_user_land.total - 1;

                set!(ctx.world, (y_warrior,y_user_land, y_user_warrior));
            }
        } //攻击失败
        else {
            lost.print();
            // 人数加回基地
            // 返回人数
            let mut user_warrior = get!(ctx.world, (map_id, ctx.origin), UserWarrior);

            let mut balance = user_warrior.balance;

            balance.print();
            random_loss_x.print();

            // 更新人数、扣减伤亡人数
            user_warrior.balance = balance - random_loss_x;

            if (troop.balance == 0) {
                troop.start_time = 0;
            }

            set!(ctx.world, (user_warrior, troop));

            if (isLand_None >= 1) {
                youzhu.print();

                if(y <= 0){
                    return ();
                }

                y = y / 100;

                if( random_loss_y >= y){
                    random_loss_y = y;
                }

                y = y - random_loss_y;

                // 剩下的人数更新
                y_warrior.balance = y;

                let mut y_user_warrior = get!(ctx.world, (map_id, y_address), UserWarrior);
                let balance = y_user_warrior.balance;

                y_user_warrior.balance.print();
                random_loss_y.print();

                y_user_warrior.balance = y_user_warrior.balance - random_loss_y;

                set!(ctx.world, (y_warrior, y_user_warrior));
            }
        }

        return ();
    }
}

