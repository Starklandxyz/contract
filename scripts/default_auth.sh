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
sleep 1
sozo auth writer Player spawn --world $WORLD_ADDRESS
sleep 1
sozo auth writer ETH spawn --world $WORLD_ADDRESS
sleep 1
sozo auth writer Base build_base --world $WORLD_ADDRESS
sleep 1
sozo auth writer Land build_base --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMining build_base --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food train_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron train_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold train_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Training train_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Training take_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior take_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer UserWarrior take_warrior --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Airdrop claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer UserWarrior claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior claim_airdrop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food send_troop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron send_troop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Troop send_troop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior send_troop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Troop retreat_troop --world $WORLD_ADDRESS
sleep 1
sozo auth writer Troop enter_land --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior enter_land --world $WORLD_ADDRESS
sleep 1
sozo auth writer Land build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer FortOwner build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandCost build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron build_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMiner start_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMining start_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer UserWarrior go_fight --world $WORLD_ADDRESS
sleep 1
sozo auth writer Land go_fight --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandOwner go_fight --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior go_fight --world $WORLD_ADDRESS
sleep 1
sozo auth writer Troop go_fight --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMining claim_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food claim_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold claim_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron claim_mining --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandCost upgrade_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer UpgradeCost upgrade_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold upgrade_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food upgrade_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron upgrade_building --world $WORLD_ADDRESS
sleep 1
sozo auth writer Warrior admin --world $WORLD_ADDRESS
sleep 1
sozo auth writer UserWarrior admin --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold admin --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food admin --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron admin --world $WORLD_ADDRESS
sleep 1
sozo auth writer Land upgrade_compleate --world $WORLD_ADDRESS
sleep 1
sozo auth writer UpgradeCost upgrade_compleate --world $WORLD_ADDRESS
sleep 1
sozo auth writer Land admin_attack --world $WORLD_ADDRESS
sleep 1

sozo auth writer UserWarrior attack_monster --world $WORLD_ADDRESS
sleep 1
sozo auth writer LuckyPack attack_monster --world $WORLD_ADDRESS
sleep 1
sozo auth writer Troop attack_monster --world $WORLD_ADDRESS
sleep 1
sozo auth writer LuckyPack open_pack --world $WORLD_ADDRESS
sleep 1
sozo auth writer RewardPoint open_pack --world $WORLD_ADDRESS
sleep 1
sozo execute init --world $WORLD_ADDRESS
sleep 1

sozo auth writer Land remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer FortOwner remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandCost remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer Food remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer Gold remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer Iron remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMining remove_build --world $WORLD_ADDRESS
sleep 1
sozo auth writer LandMiner remove_build --world $WORLD_ADDRESS
sleep 1

echo "Default authorizations have been successfully set."