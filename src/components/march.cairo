use starknet::ContractAddress;

// 部队是出现在路上行军的军团
// 用id来表示玩家军队编号,从1开始
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct March {
    #[key]
    entity: felt252,
    #[key]
    owner: ContractAddress,
    #[key]
    id: u64,

}