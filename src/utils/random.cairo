use traits::{Into, TryInto};
use array::ArrayTrait;
use debug::PrintTrait;

// return a u64 number.
fn random(seed: u64) -> u128  {
    let seed_felt: felt252 = seed.into();
    let mut rolling_seed_arr: Array<felt252> = ArrayTrait::new();
    rolling_seed_arr.append(seed_felt);
    rolling_seed_arr.append(seed_felt * 7);
    rolling_seed_arr.append(seed_felt * 29);

    let rolling_hash: u256 = poseidon::poseidon_hash_span(rolling_seed_arr.span()).into();
    // rolling_hash.print();
    let x: u128 = (rolling_hash.low);
    // x.print();
    x
}


#[cfg(test)]
mod tests {
    use core::debug::PrintTrait;
use super::random;
    //use debug::PrintTrait; X
    #[test]
    #[available_gas(30000000)]

    fn test_random() {
        // result1 == result2
        let seed1  = starknet::get_block_timestamp();   
        let result1 = random(seed1);
        let seed2  = starknet::get_block_timestamp();   
        let result2 = random(seed2);
        // result3 == result4
        let seed3: u64  = 1000;   
        let result3 = random(seed3);
        let seed4: u64 = 2000;   
        let result4 = random(seed4);
        assert((result1 == result2) && (result2 != result3 ) && (result3 != result4) , 'random err');

        let r = random(10);
        let x = 2;
        let y = 1;
        let map_id=1;
        let r1 = random(x * 99 + y + map_id * 17) % 100_u128 + 1_u128; // 1-100
        let r2:u64 = r1.try_into().unwrap();
        r2.print();
    }

    
}
