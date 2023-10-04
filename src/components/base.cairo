use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Base {
    #[key]
    id: ContractAddress,
    x: u64,
    y: u64,
}