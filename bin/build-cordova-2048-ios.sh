#!/bin/bash

cd "${WORKSPACE}"

# Clean old artifacts
rm -rf "platforms/ios/Cordova-2048.xcarchive"
rm -rf "platforms/ios/Cordova-2048.xcarchive.zip"
rm -rf "platforms/ios/Skillz.framework"
rm -rf "platforms/ios/build"

unzip -q 'Skillz.framework.zip' -d "./platforms/ios/"

cd "platforms/ios"

export SDKVERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${WORKSPACE}/platforms/ios/Cordova 2048/Skillz.framework/Info.plist")
export NEW_TAG=`git describe --match '*.*.*'`

export SDKVERSION=${SDKVERSION}

echo ${SDKVERSION}

# Set Version numbers.
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString \"${SDKVERSION}\"" -c "Save" "${WORKSPACE}/platforms/ios/Cordova 2048/Cordova 2048-Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion \"${NEW_TAG}\"" -c "Save" "${WORKSPACE}/platforms/ios/Cordova 2048/Cordova 2048-Info.plist"

# # Set bundle identifier
# /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier \"com.skillz.enterprise.cordova.2048\"" -c "Save" "${WORKSPACE}/platforms/ios/Cordova 2048/Cordova 2048-Info.plist"

# Copy over the custom theme into Skillz.framework.
cp "${WORKSPACE}/themes/theme.json" "${WORKSPACE}/platforms/ios/Cordova 2048/Skillz.framework/theme.json"

# Compile Enterprise Archive.
set -o pipefail && xcodebuild -sdk iphoneos -scheme "Cordova 2048" -configuration Enterprise clean archive \
-archivePath "./Cordova-2048" ONLY_ACTIVE_ARCH=NO BUILD_DIR=./build CODE_SIGN_IDENTITY="iPhone Distribution: Skillz Inc" | xcpretty

# Build IPA for Crashlytics.
xcodebuild -exportArchive -archivePath "./Cordova-2048.xcarchive" -exportOptionsPlist "${WORKSPACE}/provisioning/EnterpriseArchive.plist" \
-exportPath "${WORKSPACE}/Enterprise/" | xcpretty

# Zip Enterprise Archive for storing on Jenkins artifacts.
zip -y -r Cordova-2048.xcarchive.zip Cordova-2048.xcarchive

cd "${WORKSPACE}"