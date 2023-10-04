use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Base {
    #[key]
    id: ContractAddress,
    #[key]
    map_id:u64,
    x: u64,
    y: u64,
}