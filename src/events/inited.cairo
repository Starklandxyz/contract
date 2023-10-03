#[derive(Drop, Clone, Serde, PartialEq, starknet::Event)]
struct MapInited {
    id: u64,
    MAX_MAP_X: u64,
    MAX_MAP_Y: u64
}

#[derive(Drop, Clone, Serde, PartialEq, starknet::Event)]
enum Event {
    MapInited: MapInited
}


