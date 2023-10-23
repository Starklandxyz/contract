use starknet::ContractAddress;
use stark_land::utils::random::random;

//地块开采的状态
//地块可以是农场/金矿/铁矿场
//用来记录最后一次开始采矿/种地的时间
//每次用户收获之后，都把时间改为当前时间
#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct LandMining {
    #[key]
    map_id: u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    start_time:u64,
    //挖矿的位置
    mined_x:u64,
    mined_y:u64
}
