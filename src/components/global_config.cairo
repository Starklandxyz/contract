#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct GlobalConfig {
    #[key]
    map_id: u64,
    MAX_MAP_X: u64,
    MAX_MAP_Y: u64,

    //用来给所有的资源做乘积
    MULTIPLIER:u64,
}