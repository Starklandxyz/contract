use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct LandCost {
    #[key]
    map_id:u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    cost_gold: u64, //建筑总gold成本
    cost_food: u64, //建筑总food成本
    cost_iron: u64, //建筑总iron成本
}