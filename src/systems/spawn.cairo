#[system]
mod spawn {
    use array::ArrayTrait;
    use box::BoxTrait;
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use dojo::world::Context;

    use stark_land::components::player::Player;
    use stark_land::components::eth::ETH;

    fn execute(ctx: Context, nick_name: felt252) {
        let time_now: u64 = starknet::get_block_timestamp();

        let player = get!(ctx.world, ctx.origin, (Player));
        assert(player.joined_time == 0, 'you have joined!');

        set!(
            ctx.world,
            (
                Player {
                    owner: ctx.origin, // 玩家钱包地址
                    nick_name: nick_name,
                    joined_time: time_now
                },
            )
        );
        set!(ctx.world, (ETH { owner: ctx.origin, balance: 500_000_000_000_000_000 }));
        return ();
    }
}
