#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct WarriorConfig {
    #[key]
    map_id: u64,

    //训练士兵的消耗和时间
    Train_Food:u64,  
    Train_Gold:u64,
    Train_Iron:u64,
    Train_Time:u64,

    //派兵的消耗的时间
    Troop_Food:u64,
    Troop_Gold:u64,
    Troop_Iron:u64,
    Troop_Speed:u64
}