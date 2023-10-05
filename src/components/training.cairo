use starknet::ContractAddress;

//训练士兵
#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Training {
    #[key]
    map_id: u64,
    #[key]
    owner: ContractAddress,
    start_time: u64,
    total: u64, // total train
    out: u64, // already take out amount
}

#[generate_trait]
impl TrainImpl of TrainTrait {
    fn end_time(self: @Training, train_time: u64) -> u64 {
        *self.start_time + *self.total * train_time
    }

    fn can_take_out_amount(self: @Training, train_time: u64, time_now: u64) -> u64 {
        let total_time = time_now - *self.start_time;
        let total_trained = total_time/train_time;
        total_trained - *self.out
    }
}
