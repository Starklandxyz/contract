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

sozo auth writer Player spawn --world $WORLD_ADDRESS
sozo auth writer ETH spawn --world $WORLD_ADDRESS
sozo auth writer Base build_base --world $WORLD_ADDRESS
sozo auth writer Land build_base --world $WORLD_ADDRESS
sozo auth writer GlobalConfig init --world $WORLD_ADDRESS

sozo auth writer Food train_warrior --world $WORLD_ADDRESS
sozo auth writer Iron train_warrior --world $WORLD_ADDRESS
sozo auth writer Gold train_warrior --world $WORLD_ADDRESS
sozo auth writer Training train_warrior --world $WORLD_ADDRESS

sozo auth writer Training take_warrior --world $WORLD_ADDRESS
sozo auth writer Warrior take_warrior --world $WORLD_ADDRESS

sozo auth writer Food admin --world $WORLD_ADDRESS
sozo auth writer Gold admin --world $WORLD_ADDRESS
sozo auth writer Iron admin --world $WORLD_ADDRESS

sozo execute init --world $WORLD_ADDRESS

echo "Default authorizations have been successfully set."