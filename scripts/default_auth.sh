#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..


export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

# export ACTIONS_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "spawn" ).address')

get_contract_address() {
    local contract_name=$1
    echo $(cat ./target/dev/manifest.json | jq -r --arg name "$contract_name" '.contracts[] | select(.name == $name ).address')
}

echo "---------------------------------------------------------------------------"
echo rpc : $RPC_URL
echo " "
echo world : $WORLD_ADDRESS 
echo " "
echo actions : $(get_contract_address "spawn")
echo "---------------------------------------------------------------------------"

sozo auth writer Player $(get_contract_address "spawn") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer ETH $(get_contract_address "spawn") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer HBase $(get_contract_address "build_base") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Land $(get_contract_address "build_base") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMining $(get_contract_address "build_base") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Training $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Training $(get_contract_address "take_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "take_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "take_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Airdrop $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "claim_airdrop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
# sozo auth writer Food send_troop --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron send_troop --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Troop send_troop --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Warrior send_troop --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Troop retreat_troop --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Troop enter_land --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Warrior enter_land --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Land build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer FortOwner build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandCost build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Food build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Gold build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron build_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandMiner start_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandMining start_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer UserWarrior go_fight --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Land go_fight --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandOwner go_fight --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Warrior go_fight --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Troop go_fight --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandMining claim_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Food claim_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Gold claim_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron claim_mining --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandCost upgrade_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer UpgradeCost upgrade_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Gold upgrade_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Food upgrade_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron upgrade_building --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Warrior admin --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer UserWarrior admin --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Gold admin --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Food admin --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron admin --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Land upgrade_compleate --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer UpgradeCost upgrade_compleate --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Land admin_attack --world $WORLD_ADDRESS
# sleep 1

# sozo auth writer UserWarrior attack_monster --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LuckyPack attack_monster --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Troop attack_monster --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LuckyPack open_pack --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer RewardPoint open_pack --world $WORLD_ADDRESS
# sleep 1

# sozo auth writer Land remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer FortOwner remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandCost remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Food remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Gold remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer Iron remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandMining remove_build --world $WORLD_ADDRESS
# sleep 1
# sozo auth writer LandMiner remove_build --world $WORLD_ADDRESS
# sleep 1

sozo execute $(get_contract_address "init") execute
echo "Default authorizations have been successfully set."