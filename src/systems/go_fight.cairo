#[system]
mod go_fight {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::fight::Fight;
    use stark_land::components::fight::FightImpl;

    use stark_land::components::base::Base;
    use stark_land::components::user_warrior::UserWarrior;
    use stark_land::components::warrior::Warrior;
    use stark_land::components::warrior_config::WarriorConfig;

    use stark_land::components::troop::Troop;
    use stark_land::components::Troop::TroopImpl;

    use rand::Rng;

    fn execute(ctx: Context, map_id: u64,my_troop_id: u64,other_troop_id: u64) {

        // 根据MapId 获取地址，已经获取到对方玩家信息、计算双方人数、时间复杂度最少

        let time_now: u64 = starknet::get_block_timestamp();

        let mut my_troop = get!(ctx.world, (map_id, ctx.origin, my_troop_id), Troop);
        let mut other_troop = get!(ctx.world, (map_id, ctx.origin, other_troop_id), Troop);
        
        // x 人数、y 人数，y 实际攻击力是 y * 1.3、
        // 胜率是 x = x / 1.3*y + x , x 损失人数是 [0，（1 -（ x / 1.3*y + x]  的随机值 * x 
        // 胜率是 y = 1.3*y / 1.3*y + x , x 损失人数是 [0,（1 -（ y / 1.3*y + x）* y]  的随机值 * y
        // 胜率高 伤亡人数少

        // 扩大 100 倍
        let actual_attack_power_y = y * 130; // 扩大 100 倍
        let win_rate_x = x * 10000 / (actual_attack_power_y + x * 100);   // x 放大 10000 和胜负率.类似
        let random_loss_x = rand::thread_rng().gen_range(0..(100 - win_rate_x)) * x / 100;
    
        let win_rate_y = actual_attack_power_y *10000 / (actual_attack_power_y + x * 100);
        let random_loss_y = rand::thread_rng().gen_range(0..(100 - win_rate_y)) * y / 100;

        // 更新人数，放大 100 最后缩小 100 是否丢失精度
        // 更新双方人员数据 
    
        set!(ctx.world, (training, warrior,user_warrior));
        return ();
    }
}
