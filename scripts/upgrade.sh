#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..


# export RPC_URL="http://localhost:5050";
export RPC_URL="https://api.cartridge.gg/x/starklandv001/katana";

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

sozo execute $(get_contract_address "init") execute
echo "Default authorizations have been successfully set."