use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Gold {
    #[key]
    id: ContractAddress,
    balance: u64,
}
