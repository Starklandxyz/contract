#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..


export RPC_URL="http://localhost:5050";
# export RPC_URL="https://api.cartridge.gg/x/starklandv001/katana";

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

sozo auth writer Food $(get_contract_address "send_troop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "send_troop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Troop $(get_contract_address "send_troop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "send_troop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Troop $(get_contract_address "retreat_troop") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Troop $(get_contract_address "enter_land") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "enter_land") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Land $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer FortOwner $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandCost $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "build_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMiner $(get_contract_address "start_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMining $(get_contract_address "start_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "go_fight") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Land $(get_contract_address "go_fight") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandOwner $(get_contract_address "go_fight") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "go_fight") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Troop $(get_contract_address "go_fight") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMining $(get_contract_address "claim_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "claim_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "claim_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "claim_mining") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandCost $(get_contract_address "upgrade_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UpgradeCost $(get_contract_address "upgrade_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "upgrade_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "upgrade_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "upgrade_building") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Warrior $(get_contract_address "admin") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "admin") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "admin") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "admin") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "admin") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Land $(get_contract_address "upgrade_compleate") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UpgradeCost $(get_contract_address "upgrade_compleate") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "attack_monster") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LuckyPack $(get_contract_address "attack_monster") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Troop $(get_contract_address "attack_monster") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LuckyPack $(get_contract_address "open_pack") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer RewardPoint $(get_contract_address "open_pack") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1

sozo auth writer Land $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer FortOwner $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandCost $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Food $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Gold $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer Iron $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMining $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer LandMiner $(get_contract_address "remove_build") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1

sozo execute $(get_contract_address "init") execute
echo "Default authorizations have been successfully set."