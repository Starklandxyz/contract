use starknet::ContractAddress;

// 士兵
// 士兵可以出现在基地，出现在任意地块，出现在路上行军的军团
// 用entity来表示处于的地方
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Warrior {
    #[key]
    entity: felt252,
    #[key]
    owner: ContractAddress,
    balance: u64,
}