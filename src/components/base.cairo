use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Base {
    #[key]
    map_id:u64,
    #[key]
    owner: ContractAddress,
    x: u64,
    y: u64,
}