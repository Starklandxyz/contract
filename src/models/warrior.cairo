use starknet::ContractAddress;

// 士兵可以出现在基地，出现在任意地块
#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct Warrior {
    #[key]
    map_id: u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    balance: u64,
}