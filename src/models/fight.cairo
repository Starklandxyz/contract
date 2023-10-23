use starknet::ContractAddress;

//攻击计算
#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct Fight {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    total: u64, 
    out: u64, 
}

#[generate_trait]
impl FightImpl of FightTrait {

    fn win_rate(self: @Fight, my_warriors_num: u64, other_warriors_num: u64) -> u64 {

        // 胜率是固定，根据当前人数而定
        my_warriors_num * 10000/ (my_warriors_num * 100 + other_warriors_num * 130)

        // 返回的是 1 - 100 的数，40 即代表 40% 胜率，80 代表 80%


    }
}
