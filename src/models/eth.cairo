//玩家

use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct ETH {
    #[key]
    owner: ContractAddress,
    balance: u128,
}
