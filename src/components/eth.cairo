//玩家

use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct ETH {
    #[key]
    id: ContractAddress,
    balance: u128,
}
