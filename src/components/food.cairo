use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Food {
    #[key]
    id: ContractAddress,
    balance: u64,
}
