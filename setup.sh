#!/bin/bash
set -e
versions=("rn66" "rn65" "rn64" "rn63")

for index in {0..3}
do 
    cd ${versions[$index]}
    cp ../react-native-reanimated-*.tgz ./react-native-reanimated.tgz
    rm -rf node_modules && yarn
    cd ios
    pod deintegrate && pod install
    cd ../../
done