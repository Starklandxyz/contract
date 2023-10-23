use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct RewardPoint {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    balance: u64, // 玩家积分数量
}