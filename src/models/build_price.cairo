use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct BuildPrice {
    #[key]
    map_id:u64,
    #[key]
    build_type: u64,

    gold:u64,
    food:u64,
    iron:u64
}