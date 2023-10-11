use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Airdrop {
    #[key]
    map_id:u64,
    #[key]
    owner: ContractAddress,
    #[key]
    index: u64,
    claimed: bool,
}
