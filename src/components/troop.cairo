use starknet::ContractAddress;

// 部队是玩家的军团
// 用index来表示玩家军队编号,从1开始
// 每个军团人数从1起
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Troop {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    #[key]
    index: u64,
    balance: u64,
    //军团出发地点和目的地
    from_x: u64,
    from_y: u64,
    to_x: u64,
    to_y: u64,
    //出发时间
    start_time: u64,
    distance:u64,
    retreat:bool
}

#[generate_trait]
impl TroopImpl of TroopTrait {
    fn end_time(self: @Troop, troop_speed: u64) -> u64 {
        let dis = TroopTrait::distance(*self.from_x,*self.from_y,*self.to_x,*self.to_y);
        let end_time = *self.start_time + dis * troop_speed;
        end_time
    }

    fn distance(from_x: u64, from_y: u64, to_x: u64, to_y: u64) -> u64 {
        let mut x_diff = 0;
        let mut y_diff = 0;
        if (from_x > to_x) {
            x_diff = from_x - to_x;
        } else {
            x_diff = to_x - from_x;
        }
        if (from_y > to_y) {
            y_diff = from_y - to_y;
        } else {
            y_diff = to_y - from_y;
        }
        let dis =  x_diff + y_diff;
        dis
    }
}
