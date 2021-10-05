#!/bin/bash
set -e
versions=("rn66" "rn65" "rn64" "rn63")
directory=$(pwd)
logfile_prefix="${directory}/logs"

for index in {0..3}
do
    version_logfile="${logfile_prefix}_${versions[$index]}"
    echo "Testing ${versions[$index]}"
    cd ${versions[$index]}
    echo "Testing ios"
    xcodebuild -workspace ios/${versions[$index]}.xcworkspace -scheme ${versions[$index]} -configuration Release -sdk iphonesimulator -derivedDataPath ios/build >> $version_logfile
    echo "Testing android"
    react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res  >> $version_logfile && cd android && ./gradlew :app:assembleDebug >> $version_logfile && cd ..
    cd ..
    android_successful=$(cat $version_logfile | grep "BUILD SUCCESSFUL" -c)
    ios_succeeded=$(cat $version_logfile | grep "BUILD SUCCEEDED" -c)
    if [ "$android_successful" != "1" ]; then
        echo "Android build failed. Check logs to get more info."
        echo $(cat $version_logfile)
        exit 1
    elif [ "$ios_succeeded" != "1" ]; then
        echo "IOS build failed. Check logs to get more info."
        echo $(cat $version_logfile)
        exit 1
    fi
    echo "${versions[$index]} tested successfully!"
done

echo "Done!"