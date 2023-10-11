#[system]
mod init {
    use dojo::world::Context;

    use stark_land::components::global_config::GlobalConfig;
    use stark_land::components::warrior_config::WarriorConfig;
    use stark_land::components::build_config::BuildConfig;
    use stark_land::components::build_price::BuildPrice;
    use stark_land::components::mining_config::MiningConfig;

    #[event]
    use stark_land::events::inited::{Event, MapInited};

    fn execute(ctx: Context) {
        let max_map_x: u64 = 100;
        let max_map_y: u64 = 100;
        let multiplier: u64 = 1_000_000;

        set!(
            ctx.world,
            (
                GlobalConfig {
                    map_id: 1, MULTIPLIER: multiplier, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y
                },
            )
        );
        set!(
            ctx.world,
            (
                WarriorConfig {
                    map_id: 1,
                    Train_Food: 20 * multiplier,
                    Train_Gold: 10 * multiplier,
                    Train_Iron: 0 * multiplier,
                    Train_Time: 10,
                    Troop_Food: 10 * multiplier,
                    Troop_Gold: 0 * multiplier,
                    Troop_Speed: 10
                },
            )
        );
        set!(
            ctx.world,
            (BuildConfig {
                map_id: 1,
                Land_Gold: 1, //土地属性是金矿的值,默认是1
                Land_Iron: 3, //土地属性是铁矿的值,默认是3
                Land_Water: 5, //土地属性是水的值,默认是5
                Land_None: 6, //土地属性是可建设用地的值,默认是6
                // 1==基地Base 4*4,2==农田Farmland,3==铁矿矿场IronMine,4==金矿矿场GoldMine,5==营地Camp
                Build_Type_Base: 1,
                Build_Type_Farmland: 2,
                Build_Type_IronMine: 3,
                Build_Type_GoldMine: 4,
                Build_Type_Camp: 5,
            })
        );
        set!(
            ctx.world,
            (MiningConfig {
                map_id: 1,
                Food_Speed: multiplier / 1, // 1.0 per sec
                Gold_Speed: multiplier / 1, //
                Iron_Speed: multiplier / 1, //
                Base_Gold_Speed: multiplier / 1,
            })
        );
        set!(
            ctx.world,
            (BuildPrice {
                map_id: 1,
                build_type: 1,
                gold: 100 * multiplier,
                food: 100 * multiplier,
                iron: 100 * multiplier
            })
        );
        set!(
            ctx.world,
            (BuildPrice {
                map_id: 1,
                build_type: 2,
                gold: 100 * multiplier,
                food: 100 * multiplier,
                iron: 100 * multiplier
            })
        );
        set!(
            ctx.world,
            (BuildPrice {
                map_id: 1,
                build_type: 3,
                gold: 100 * multiplier,
                food: 100 * multiplier,
                iron: 100 * multiplier
            })
        );
        set!(
            ctx.world,
            (BuildPrice {
                map_id: 1,
                build_type: 4,
                gold: 100 * multiplier,
                food: 100 * multiplier,
                iron: 100 * multiplier
            })
        );
        set!(
            ctx.world,
            (BuildPrice {
                map_id: 1,
                build_type: 5,
                gold: 100 * multiplier,
                food: 100 * multiplier,
                iron: 100 * multiplier
            })
        );

        emit!(ctx.world, MapInited { map_id: 1, MAX_MAP_X: max_map_x, MAX_MAP_Y: max_map_y });

        return ();
    }
}
