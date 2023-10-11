use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct UpgradeCost {
    #[key]
    map_id:u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    start_time: u64, //开始升级的时间
    end_time: u64, //结束升级的时间
    target_level: u64, //目标等级
    claimed: bool, // 是否 claim 该等级
}