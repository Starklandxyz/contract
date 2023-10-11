use starknet::ContractAddress;
use stark_land::utils::random::random;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Land {
    #[key]
    map_id: u64,
    #[key]
    x: u64,
    #[key]
    y: u64,
    owner: ContractAddress,
    building: u64, // 1==基地Base 4*4,2==农田Farmland,3==铁矿矿场IronMine,4==金矿矿场GoldMine,5==营地Camp
    level: u64,
}

#[generate_trait]
impl LandImpl of LandTrait {
    //土地属性为1-100的随机数,其中 1 是金矿,2~3是铁矿,4~5是水【均无法占领和建设】
    fn land_property(map_id: u64, x: u64, y: u64) -> u64 {
        let r1 = random(x * 99 + y + map_id * 17) % 100_u128 + 1_u128; // 1-100
        let r2: u64 = r1.try_into().unwrap();
        r2
    }

    //土著蛮族人数为1-400的随机数
    fn land_barbarians(map_id: u64, x: u64, y: u64) -> u64 {
        let r1: u128 = random(x * 999 + y * 3 + map_id * 77) % 100 + 1; // 1-100
        //level1:35%, level2: 30% level3:20%, level4:10%, level5:5%
        //leve 1 : 1-20, 2: 21-50, 3: 51-100 4:101-200 5:201-400
        let r2: u128 = random(x * 99 + y * 4 + map_id * 7); 
        let mut result:u64 = 1;
        if (r1 <= 35) {
            result = (r2%20+1).try_into().unwrap()
        }else if(r1<=65){
            result = (r2%30+21).try_into().unwrap()
        }else if(r1<=85){
            result = (r2%50+51).try_into().unwrap()
        }else if(r1<=95){
            result = (r2%100+101).try_into().unwrap()
        }else if(r1<=100){
            result = (r2%200+201).try_into().unwrap()
        }
        // r1.try_into().unwrap()
        result
    }
}


#[cfg(test)]
mod tests {
    use super::{LandTrait};
    #[test]
    #[available_gas(100000)]
    fn test_land_property() {
        assert(LandTrait::land_property(map_id: 1, x: 333, y: 666) <= 100, 'biger than 100');
    }

    #[test]
    #[available_gas(100000)]
    fn test_land_barbarians() {
        //TODO: should update test
        assert(LandTrait::land_barbarians(map_id: 1, x: 333, y: 666) <= 100, 'biger than 100');
    }
}
