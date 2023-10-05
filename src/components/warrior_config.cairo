#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct WarriorConfig {
    #[key]
    map_id: u64,

    //训练士兵的消耗和时间
    Train_Food:u64,  
    Train_Gold:u64,
    Train_Time:u64,
}