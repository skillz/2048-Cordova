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

if [ -z "${NEW_TAG}" ]; then
    echo "No release tag found on GitHub, using the default app version."
    export NEW_TAG="1.0.0"
fi

export SDKVERSION=${SDKVERSION}

echo "SDK version = ${SDKVERSION}"
echo "App version = ${NEW_TAG}"

# Set Version numbers.
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString \"${SDKVERSION}\"" -c "Save" "${WORKSPACE}/platforms/ios/Cordova 2048/Cordova 2048-Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion \"${NEW_TAG}\"" -c "Save" "${WORKSPACE}/platforms/ios/Cordova 2048/Cordova 2048-Info.plist"

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

# Retrieve Fabric API and Build secrets from Sidious
printf "Retrieving Fabric API and Build secrets from /etc/fabric.properties"
line_one=$(sed '1q;d' /etc/fabric.properties)
line_two=$(sed '2q;d' /etc/fabric.properties)

echo ${line_one}
echo ${line_two}

api_secret=$(echo ${line_one} | cut -d'=' -f2)
build_secret=$(echo ${line_two} | cut -d'=' -f2)

echo ${api_secret}
echo ${build_secret}

"${WORKSPACE}/platforms/ios/Crashlytics.framework/submit" ${api_secret} \
${build_secret} \
-ipaPath "${WORKSPACE}/Enterprise/Cordova 2048.ipa" \
-groupAliases SDK,qa-2,tournament-server,product