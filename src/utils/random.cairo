use traits::{Into, TryInto};
use array::ArrayTrait;

// return a u64 number.
fn random(seed: u64) -> u64  {
    let seed_felt: felt252 = seed.into();
    let mut rolling_seed_arr: Array<felt252> = ArrayTrait::new();
    rolling_seed_arr.append(seed_felt);
    rolling_seed_arr.append(seed_felt * 7);
    rolling_seed_arr.append(seed_felt * 29);

    let rolling_hash: u256 = poseidon::poseidon_hash_span(rolling_seed_arr.span()).into();
    let x: u64 = (rolling_hash.low & 0x0000000000000000ffffffffffffffff).try_into().unwrap();
    x
}




#[cfg(test)]
mod tests {
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
    }
}
