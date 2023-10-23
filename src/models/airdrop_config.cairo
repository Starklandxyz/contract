use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct AirdropConfig {
    #[key]
    map_id: u64,
    #[key]
    index: u64,
    reward_warrior: u64,
    reward_food: u64,
    reward_gold: u64,
    reward_iron: u64,
}
