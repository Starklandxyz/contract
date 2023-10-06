use starknet::ContractAddress;

// 统计玩家的士兵数量
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct UserWarrior {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    balance: u64,
}