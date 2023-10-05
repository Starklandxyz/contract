use starknet::ContractAddress;

// 部队是玩家的军团
// 用id来表示玩家军队编号,从1开始
// 每个军团人数从1起
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Troop {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    #[key]
    id: u64,
    balance: u64,
}