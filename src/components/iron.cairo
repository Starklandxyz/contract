use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Iron {
    #[key]
    map_id: u64,
    #[key]
    id: ContractAddress,
    balance: u64,
}
