use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct LandOwner {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    total: u64,
}


#[generate_trait]
impl LandOwnerImpl of LandOwnerTrait {
    fn land_max_amount(level:u64) -> u64 {
        let maxLand:u64 = 10 + (level - 1) * 5;
        maxLand
    }
}