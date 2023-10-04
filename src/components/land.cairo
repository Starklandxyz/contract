use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Land {
    #[key]
    x: u64,
    #[key]
    y: u64,
    #[key]
    map_id: u64,
    owner: ContractAddress,
    building: u64, // 1==基地Base 4*4,2==农田Farmland,3==铁矿矿场IronMine,4==金矿矿场GoldMine,5==营地Camp
    level: u64,
}

#[generate_trait]
impl LandImpl of LandTrait {
    //土地属性为1-100的随机数,其中 1 是金矿,2~3是铁矿,4~5是水【均无法占领和建设】
    fn land_property(map_id: u64, x: u64, y: u64) -> u64 {
        random(x * 1000 + y + map_id * 15) % 100 + 1 // 1-100
    }

    //土著蛮族人数为1-50的随机数
    fn land_barbarians(map_id: u64, x: u64, y: u64) -> u64 {
        random(x * 10000 + y + map_id * 77) % 50 + 1 // 1-50
    }
}


#[cfg(test)]
mod tests {
    use super::{LandTrait};
    #[test]
    #[available_gas(100000)]
    fn test_land_property() {
        assert(LandTrait::land_property(map_id:1, x: 333, y: 666) <= 100, 'biger than 100');
    }

    #[test]
    #[available_gas(100000)]
    fn test_land_barbarians() {
        assert(LandTrait::land_barbarians(map_id:1,x: 333, y: 666) <= 50, 'biger than 100');
    }
}
