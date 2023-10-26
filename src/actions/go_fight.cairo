use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(self: @TContractState, map_id: u64, troop_index: u64);
}

// dojo decorator
#[dojo::contract]
mod go_fight {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use starknet::{ContractAddress, get_caller_address};
    use super::IActions;

    use stark_land::models::hbase::HBase;
    use stark_land::models::user_warrior::UserWarrior;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::warrior_config::WarriorConfig;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::troop::Troop;
    use stark_land::models::fort_owner::FortOwner;
    use stark_land::models::troop::TroopImpl;
    use stark_land::models::land::Land;
    use stark_land::models::land::LandTrait;
    use stark_land::models::land_owner::LandOwner;
    use stark_land::models::land_owner::LandOwnerTrait;

    use stark_land::utils::random::random;
    use debug::PrintTrait;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn execute(self: @ContractState, map_id: u64, troop_index: u64) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let mut land_owner = get!(world, (map_id, origin), LandOwner);
            let base = get!(world, (map_id, origin), HBase);
            let land = get!(world, (map_id, base.x, base.y), Land);
            let maxLand = LandOwnerTrait::land_max_amount(land.level);
            assert(land_owner.total < maxLand, 'exceed max land');

            // 根据 troop_index 获取我方派出的兵团
            let mut troop = get!(world, (map_id, origin, troop_index), Troop);
            assert(troop.start_time != 0, 'no troop');

            // 判断是否到达目的地
            // 速度 时间 距离  实际距离 = 实际速度 * 时间
            let config = get!(world, map_id, WarriorConfig);
            let total_time = troop.distance * config.Troop_Speed;

            let build_config = get!(world,(map_id),BuildConfig);

            //at the end of the troop

            // 没到达
            assert((time_now - troop.start_time) > total_time, 'not reached, can not fight');

            assert(troop.balance > 0, 'no balance, can not fight');

            let mut land = get!(world, (map_id, troop.to_x, troop.to_y), Land);

            let mut x: u64 = troop.balance * 100;
            let mut y: u64 = 0;

            let mut total_y: u64 = 0;
            let mut total_x: u64 = x;

            let y_address: ContractAddress = land.owner;

            let mut isLand_None: u64 = 0;

            let owner = land.owner;

            let mut y_warrior = get!(world, (map_id, troop.to_x, troop.to_y), Warrior);

            let barbarians: u64 = LandTrait::land_barbarians(map_id, troop.to_x, troop.to_y);

            if (!owner.is_zero()) {
                assert(land.owner != origin, 'your land can not fight');
                // 获取士兵 可能有士兵 可能没士兵
                y = y_warrior.balance * 100;
                isLand_None = 1;

                total_y = y + barbarians * 100;
            } else {
                // 如果是无主之地，获取野蛮人数量
                isLand_None = 0;

                total_y = barbarians * 100;
            }

            // x 人数、y 人数，y 实际攻击力是 y * 1.3、
            // 胜率是 x = x / 1.3*y + x , x 损失人数是 [0，（1 -（ x / 1.3*y + x]  的随机值 * x
            // 胜率是 y = 1.3*y / 1.3*y + x , x 损失人数是 [0,（1 -（ y / 1.3*y + x）* y]  的随机值 * y
            // 胜率高 伤亡人数少

            let y_power: u64 = total_y * 130 / 100;

            let xr1: u128 = random(x * 99 + y + map_id * 17 + time_now) % 10_u128 + 1_u128;
            let xr2: u64 = xr1.try_into().unwrap();

            let mut random_loss_x: u64 = total_x
                * (y_power + xr2)
                * 100
                / (x + y_power + xr2)
                / 100;

            let mut random_loss_y: u64 = total_y * (x + xr2) * 100 / (x + y_power + xr2) / 100;

            total_x.print();
            total_y.print();

            random_loss_x.print();
            random_loss_y.print();

            total_x = total_x / 100;
            total_y = total_y / 100;

            random_loss_x = random_loss_x / 100;
            random_loss_y = random_loss_y / 100;

            if (random_loss_x <= 0) {
                random_loss_x = 1;
            }

            if (random_loss_y <= 0) {
                random_loss_y = 1;
            }

            if (random_loss_x >= total_x) {
                random_loss_x = total_x;
            }

            if (random_loss_y >= total_y) {
                random_loss_y = total_y;
            }

            total_x = total_x - random_loss_x;

            total_y = total_y - random_loss_y;

            troop.balance = total_x;

            troop.balance.print();

            // 一轮结束，谁剩下人数多就赢

            let win: u64 = 1;
            let lost: u64 = 2;

            let youzhu = 111;
            //攻击方胜利
            if (total_x > total_y) {
                win.print();

                land.owner = troop.owner;
                let mut warrior = get!(world, (map_id, troop.to_x, troop.to_y), Warrior);

                warrior.balance = total_x;

                warrior.balance.print();

                //删除兵团
                troop.start_time = 0;

                x = x / 100;

                let mut user_warrior = get!(world, (map_id, origin), UserWarrior);

                user_warrior.balance = user_warrior.balance - (x - total_x);
                land_owner.total = land_owner.total + 1;
                // 更新土地 士兵信息
                set!(world, (warrior, land_owner, land, user_warrior, troop));

                if (land.building == build_config.Build_Type_Fort) {
                    let mut fort_attacker = get!(world, (map_id, origin), FortOwner);
                    let mut fort_defender = get!(world, (map_id, land.owner), FortOwner);
                    fort_attacker.total = fort_attacker.total + 1;
                    fort_defender.total = fort_defender.total - 1;
                    set!(world, (fort_attacker, fort_defender));
                }

                if (isLand_None >= 1) {
                    youzhu.print();

                    // 有主之地 \  初始人数
                    y = y / 100;

                    // total_y 剩余、 barbarians 野人、random_loss_y 损失

                    if (total_y >= barbarians) {
                        y_warrior.balance = total_y - barbarians;
                    } else {
                        y_warrior.balance = 0;
                    }

                    // 更新当前余额

                    let mut y_user_warrior = get!(world, (map_id, y_address), UserWarrior);
                    let mut y_user_land = get!(world, (map_id, y_address), LandOwner);

                    let y_base = get!(world, (map_id, y_address), HBase);

                    let mut y_base_warrior = get!(world, (map_id, y_base.x, y_base.y), Warrior);
                    // 更新基地人数
                    y_base_warrior.balance = y_base_warrior.balance + y_warrior.balance;

                    y_user_warrior.balance = y_user_warrior.balance - (y - y_warrior.balance);
                    y_user_land.total = y_user_land.total - 1;

                    set!(world, (y_user_land, y_user_warrior, y_base_warrior));
                }
            } //攻击失败
            else {
                lost.print();
                // 返回人数
                let mut user_warrior = get!(world, (map_id, origin), UserWarrior);

                let mut balance = user_warrior.balance;

                balance.print();
                random_loss_x.print();

                x = x / 100;

                // 更新人数、扣减伤亡人数
                user_warrior.balance = balance - (x - total_x);

                if (troop.balance == 0) {
                    troop.start_time = 0;
                }

                set!(world, (user_warrior, troop));

                if (isLand_None >= 1) {
                    youzhu.print();

                    y = y / 100;

                    if (total_y >= barbarians) {
                        y_warrior.balance = total_y - barbarians;
                    } else {
                        y_warrior.balance = 0;
                    }

                    // 剩下的人数更新
                    let mut y_user_warrior = get!(world, (map_id, y_address), UserWarrior);
                    let balance = y_user_warrior.balance;

                    y_user_warrior.balance = y_user_warrior.balance + y_warrior.balance - y;

                    set!(world, (y_warrior, y_user_warrior));
                }
            }

            return ();
        }
    }
}
