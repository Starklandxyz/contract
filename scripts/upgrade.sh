#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..


# export RPC_URL="http://localhost:5050";
export RPC_URL="${1:-http://localhost:5050}"

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

sozo auth writer Warrior $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1
sozo auth writer UserWarrior $(get_contract_address "train_warrior") --world $WORLD_ADDRESS --rpc-url $RPC_URL
sleep 1

# sozo execute $(get_contract_address "init") execute
echo "Default authorizations have been successfully set."