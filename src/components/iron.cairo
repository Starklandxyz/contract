use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Iron {
    #[key]
    id: ContractAddress,
    balance: u64,
}
