use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct FortOwner {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    total: u64,
}