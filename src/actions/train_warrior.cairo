use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, ClassHash};

// define the interface
#[starknet::interface]
trait IActions<TContractState> {
    fn execute(
        self: @TContractState, map_id: u64, amount: u64, camps_x: Array<u64>, camps_y: Array<u64>
    );
    fn buy(
        self: @TContractState, map_id: u64, amount: u64, camps_x: Array<u64>, camps_y: Array<u64>
    );
    
}

// dojo decorator
#[dojo::contract]
mod train_warrior {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use super::IActions;
    use starknet::{ContractAddress, get_caller_address};

    use stark_land::models::warrior_config::WarriorConfig;
    use stark_land::models::training::Training;
    use stark_land::models::training::TrainImpl;
    use stark_land::models::build_config::BuildConfig;
    use stark_land::models::user_warrior::UserWarrior;
    use stark_land::models::warrior::Warrior;
    use stark_land::models::land::Land;
    use stark_land::models::hbase::HBase;
    use stark_land::models::food::Food;
    use stark_land::models::iron::Iron;
    use stark_land::models::gold::Gold;

    // impl: implement functions specified in trait
    #[external(v0)]
    impl ActionsImpl of IActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn buy(
            self: @ContractState, map_id: u64, amount: u64, camps_x: Array<u64>, camps_y: Array<u64>
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0 && base.y != 0, 'you not joined!');

            let config = get!(world, map_id, WarriorConfig);
            assert(config.Train_Food != 0, 'config not ready');

            let maxWarrior = calMaxWarrior(self, map_id, camps_x, camps_y);
            let mut userWarrior = get!(world, (map_id, origin), UserWarrior);
            assert(userWarrior.balance + amount <= maxWarrior, 'exceed max');

            let training = get!(world, (map_id, origin), Training);
            assert(time_now > training.end_time(config.Train_Time), 'train not finish');
            assert(
                training.can_take_out_amount(config.Train_Time, time_now) == 0, 'take warrior first'
            );
            
            let multi = 5;

            let food_need = config.Train_Food * amount * multi;
            let mut food = get!(world, (map_id, origin), Food);
            assert(food.balance >= food_need, 'food not enough');
            food.balance = food.balance - food_need;

            let iron_need = config.Train_Iron * amount * multi;
            let mut iron = get!(world, (map_id, origin), Iron);
            assert(iron.balance >= iron_need, 'iron not enough');
            iron.balance = iron.balance - iron_need;

            let gold_need = config.Train_Gold * amount * multi;
            let mut gold = get!(world, (map_id, origin), Gold);
            assert(gold.balance >= gold_need, 'gold not enough');
            gold.balance = gold.balance - gold_need;

            let mut warrior = get!(world, (map_id, base.x, base.y), Warrior);
            warrior.balance = warrior.balance + amount;

            userWarrior.balance = userWarrior.balance + amount;

            set!(world, (food, iron, gold,warrior,userWarrior));
            return ();
        }

        // ContractState is defined by system decorator expansion
        fn execute(
            self: @ContractState, map_id: u64, amount: u64, camps_x: Array<u64>, camps_y: Array<u64>
        ) {
            let time_now: u64 = starknet::get_block_timestamp();
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            // Get the address of the current caller, possibly the player's address.
            let origin = get_caller_address();

            let base = get!(world, (map_id, origin), HBase);
            assert(base.x != 0 && base.y != 0, 'you not joined!');

            let config = get!(world, map_id, WarriorConfig);
            assert(config.Train_Food != 0, 'config not ready');

            let maxWarrior = calMaxWarrior(self, map_id, camps_x, camps_y);
            let userWarrior = get!(world, (map_id, origin), UserWarrior);
            assert(userWarrior.balance + amount <= maxWarrior, 'exceed max');

            let mut training = get!(world, (map_id, origin), Training);
            assert(time_now > training.end_time(config.Train_Time), 'train not finish');
            assert(
                training.can_take_out_amount(config.Train_Time, time_now) == 0, 'take warrior first'
            );

            let food_need = config.Train_Food * amount;
            let mut food = get!(world, (map_id, origin), Food);
            assert(food.balance >= food_need, 'food not enough');
            food.balance = food.balance - food_need;

            let iron_need = config.Train_Iron * amount;
            let mut iron = get!(world, (map_id, origin), Iron);
            assert(iron.balance >= iron_need, 'iron not enough');
            iron.balance = iron.balance - iron_need;

            let gold_need = config.Train_Gold * amount;
            let mut gold = get!(world, (map_id, origin), Gold);
            assert(gold.balance >= gold_need, 'gold not enough');
            gold.balance = gold.balance - gold_need;

            training.start_time = time_now;
            training.total = amount;
            training.out = 0;

            set!(world, (food, iron, gold, training));
            return ();
        }
    }

    fn calMaxWarrior(self: @ContractState, map_id: u64, camps_x: Array<u64>, camps_y: Array<u64>) -> u64 {
        let mut total: u64 = 120;
        if (camps_x.len() == 0) {
            return total;
        }
        let world = self.world_dispatcher.read();
        let origin = get_caller_address();
        assert(camps_x.len() == camps_y.len(), 'not same');
        let build_config = get!(world, (map_id), BuildConfig);
        let mut index = 0;

        loop {
            let x: u64 = *camps_x.at(index);
            let y: u64 = *camps_y.at(index);
            let land = get!(world, (map_id, x, y), Land);
            assert(land.owner == origin, 'not your land');
            assert(land.building == build_config.Build_Type_Camp, 'not camp');

            total += (land.level-1) * 20 + 60;
            index += 1;
            if (index == camps_x.len()) {
                break;
            };
        };
        total
    }
}
