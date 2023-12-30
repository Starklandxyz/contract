use traits::{Into, TryInto};
use array::ArrayTrait;
use debug::PrintTrait;

// Calculate the distance traveled by troops in real time
// For testing only. Coordinate values and time ranges need to be considered
fn position(x1: u64 , y1: u64 , x2: u64 , y2: u64 , time_start: u64, speed:u64) -> u64  {

    let time_now: u64 = starknet::get_block_timestamp(); 
    let x = x2 - x1;
    let y = y2 - y1;    
    let z = u64_sqrt(x*x + y*y);
    let distance = ((time_now - time_start) * speed) / z;
    z
}