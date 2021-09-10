#!/bin/bash
set -e
versions=("rn65" "rn64" "rn63" "rn62")

for index in {0..3}
do
    echo "Testing ${versions[$index]}"
    cd ${versions[$index]}
    echo "Testing ios"
    xcodebuild -workspace ios/${versions[$index]}.xcworkspace -scheme ${versions[$index]} -configuration Release -sdk iphonesimulator -derivedDataPath ios/build
    echo "Testing android"
    react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res && cd android && ./gradlew :app:assembleDebug && cd ..
    cd ..
done

echo "Done!"