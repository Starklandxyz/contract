#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct BuildConfig {
    #[key]
    map_id: u64,
    Land_Gold: u64, //土地属性是金矿的值,默认是1
    Land_Iron: u64, //土地属性是铁矿的值,默认是3
    Land_Water: u64, //土地属性是水的值,默认是5
    Land_None: u64, //土地属性是可建设用地的值,默认是6
    // 1==基地Base 4*4,2==农田Farmland,3==铁矿矿场IronMine,4==金矿矿场GoldMine,5==营地Camp
    Build_Type_Base: u64,
    Build_Type_Farmland: u64,
    Build_Type_IronMine: u64,
    Build_Type_GoldMine: u64,
    Build_Type_Camp: u64,
}
