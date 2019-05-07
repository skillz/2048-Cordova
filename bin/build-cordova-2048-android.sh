#!/bin/bash

# 'Clean' previous build output.
cd "${WORKSPACE}/platforms/android"
rm -rf "./app/build"

# Copy `build-extras.gradle` file over.
cd "${WORKSPACE}/bin"
cp "build-extras.gradle" "${WORKSPACE}/platforms/android/app/build-extras.gradle"

# Copy fabric.properties file over. The source path used lives on Sidious.
cp "/etc/fabric.properties" "${WORKSPACE}/platforms/android/app/fabric.properties"

# Copy the release signing properties file over.
# NOTE: The keystore file is stored on Sidious.
cp "release-signing.properties" "${WORKSPACE}/platforms/android/release-signing.properties"

# Copy over the custom theme
cd "${WORKSPACE}/themes"
cp "custom_theme.json" "${WORKSPACE}/platforms/android/app/src/main/assets/custom_theme.json"

# Compile the app.
cd "${WORKSPACE}/platforms/android"
./gradlew :app:assembleRelease :app:crashlyticsUploadDistributionRelease
