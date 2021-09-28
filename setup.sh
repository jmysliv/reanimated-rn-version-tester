#!/bin/bash
set -e
versions=("rn65" "rn64" "rn63" "rn62")

for index in {0..3}
do 
    cd ${versions[$index]}
    cp ../react-native-reanimated-*.tgz ./react-native-reanimated.tgz
    rm -rf node_modules && yarn
    cd ios
    pod deintegrate && pod install
    cd ../../
done