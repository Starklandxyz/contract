use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Player {
    #[key]
    id: ContractAddress,
    nick_name: felt252, // 玩家昵称
    joined_time: u64, // 加入时间(区块时间戳)
}