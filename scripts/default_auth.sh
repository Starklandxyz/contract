#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export WORLD_ADDRESS="0x84486b8e9ffe38978b33c9d7685d9d2d487d0e9f096a1d2669edefc8506c35";

# enable system -> component authorizations
# COMPONENTS=("Base" "Food" "GlobalConfig" "" )

# for component in ${COMPONENTS[@]}; do
#     sozo auth writer $component spawn --world $WORLD_ADDRESS
# done

# for component in ${COMPONENTS[@]}; do
#     sozo auth writer $component move --world $WORLD_ADDRESS
# done
sozo auth writer GlobalConfig init --world $WORLD_ADDRESS

sozo auth writer Player spawn --world $WORLD_ADDRESS
sozo auth writer ETH spawn --world $WORLD_ADDRESS

sozo auth writer Base build_base --world $WORLD_ADDRESS
sozo auth writer Land build_base --world $WORLD_ADDRESS
sozo auth writer LandMining build_base --world $WORLD_ADDRESS

sozo auth writer Food train_warrior --world $WORLD_ADDRESS
sozo auth writer Iron train_warrior --world $WORLD_ADDRESS
sozo auth writer Gold train_warrior --world $WORLD_ADDRESS
sozo auth writer Training train_warrior --world $WORLD_ADDRESS

sozo auth writer Training take_warrior --world $WORLD_ADDRESS
sozo auth writer Warrior take_warrior --world $WORLD_ADDRESS
sozo auth writer UserWarrior take_warrior --world $WORLD_ADDRESS

sozo auth writer Food airdrop --world $WORLD_ADDRESS
sozo auth writer Gold airdrop --world $WORLD_ADDRESS
sozo auth writer Iron airdrop --world $WORLD_ADDRESS
sozo auth writer Airdrop airdrop --world $WORLD_ADDRESS

sozo auth writer Food send_troop --world $WORLD_ADDRESS
sozo auth writer Troop send_troop --world $WORLD_ADDRESS
sozo auth writer Warrior send_troop --world $WORLD_ADDRESS

sozo auth writer Troop retreat_troop --world $WORLD_ADDRESS

sozo auth writer Troop enter_land --world $WORLD_ADDRESS
sozo auth writer Warrior enter_land --world $WORLD_ADDRESS

sozo auth writer Land build_building --world $WORLD_ADDRESS
sozo auth writer LandCost build_building --world $WORLD_ADDRESS
sozo auth writer Food build_building --world $WORLD_ADDRESS
sozo auth writer Gold build_building --world $WORLD_ADDRESS
sozo auth writer Iron build_building --world $WORLD_ADDRESS

sozo auth writer LandMiner start_mining --world $WORLD_ADDRESS
sozo auth writer LandMining start_mining --world $WORLD_ADDRESS

sozo auth writer UserWarrior go_fight --world $WORLD_ADDRESS
sozo auth writer Land go_fight --world $WORLD_ADDRESS
sozo auth writer Warrior go_fight --world $WORLD_ADDRESS
sozo auth writer Troop go_fight --world $WORLD_ADDRESS

sozo auth writer LandMining claim_mining --world $WORLD_ADDRESS
sozo auth writer Food claim_mining --world $WORLD_ADDRESS
sozo auth writer Gold claim_mining --world $WORLD_ADDRESS
sozo auth writer Iron claim_mining --world $WORLD_ADDRESS

sozo auth writer Land admin_attack --world $WORLD_ADDRESS

sozo execute init --world $WORLD_ADDRESS

echo "Default authorizations have been successfully set."