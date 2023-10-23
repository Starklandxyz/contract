use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct HBase {
    #[key]
    map_id:u64,
    #[key]
    owner: ContractAddress,
    x: u64,
    y: u64
}