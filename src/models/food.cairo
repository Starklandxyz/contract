use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct Food {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    balance: u64,
}
