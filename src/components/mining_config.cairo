#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct MiningConfig {
    #[key]
    map_id: u64,

    //mining reward per hour at level1
    Food_Speed: u64,
    Iron_Speed: u64,
    Gold_Speed: u64,
}
