use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Airdrop {
    #[key]
    owner: ContractAddress,
    claimed: bool, 
}