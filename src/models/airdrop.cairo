use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct Airdrop {
    #[key]
    map_id:u64,
    #[key]
    owner: ContractAddress,
    #[key]
    index: u64,
    claimed: bool,
}
