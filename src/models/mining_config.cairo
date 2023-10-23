#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct MiningConfig {
    #[key]
    map_id: u64,

    //mining reward per sec at level1
    Food_Speed: u64,
    Iron_Speed: u64,
    Gold_Speed: u64,

    Base_Gold_Speed:u64,
}
