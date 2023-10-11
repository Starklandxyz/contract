use starknet::ContractAddress;
use stark_land::utils::random::random;

//用来表示该地块，正在被开采，比如金矿/铁矿被开采的情况
//如果改矿场正在被开采，就不能被其他挖矿的继续开采
//1个矿,只能容纳一个采矿场
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct LandMiner {
    #[key]
    map_id: u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    //开采矿场的地址
    miner_x: u64,
    miner_y: u64,
}
