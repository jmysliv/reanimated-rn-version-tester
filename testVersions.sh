#!/bin/bash
set -e
versions=("rn66" "rn65" "rn64" "rn63")
directory=$(pwd)
logfile="${directory}/logs"

for index in {0..3}
do
    echo "Testing ${versions[$index]}"
    cd ${versions[$index]}
    echo "Testing ios"
    xcodebuild -workspace ios/${versions[$index]}.xcworkspace -scheme ${versions[$index]} -configuration Release -sdk iphonesimulator -derivedDataPath ios/build >> $logfile
    echo "Testing android"
    react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res  >> $logfile && cd android && ./gradlew :app:assembleDebug >> $logfile && cd ..
    cd ..
done

android_successful=$(cat logs | grep "BUILD SUCCESSFUL" -c)
ios_succeeded=$(cat logs | grep "BUILD SUCCEEDED" -c)

if [ "$andoid_successful" != "4" ]; then
    echo "Android build failed. Check logs to get more info."
    echo $(cat $logfile)
    exit 1
else if [ "$ios_succeeded" != "4"]; then
    echo "IOS build failed. Check logs to get more info."
    echo $(cat $logfile)
    exit 1
fi

echo "Done!"