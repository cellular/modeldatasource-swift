#!/bin/bash
set -e; # Fail on first error

# Prepare
set -o pipefail; # xcpretty
xcodebuild -version;
xcodebuild -showsdks;

# Build Framework in Debug and Run Tests if specified
if [ $RUN_TESTS == "YES" ]; then
    xcodebuild -project "ModelDataSource.xcodeproj" -scheme "$SCHEME" -destination "$DESTINATION" -configuration Debug ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=YES test | xcpretty;
else
    xcodebuild -project "ModelDataSource.xcodeproj" -scheme "$SCHEME" -destination "$DESTINATION" -configuration Debug ONLY_ACTIVE_ARCH=NO build | xcpretty;
fi
# Build Framework in Release and Run Tests if specified
if [ $RUN_TESTS == "YES" ]; then
    xcodebuild -project "ModelDataSource.xcodeproj" -scheme "$SCHEME" -destination "$DESTINATION" -configuration Release ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=YES test | xcpretty;
else
    xcodebuild -project "ModelDataSource.xcodeproj" -scheme "$SCHEME" -destination "$DESTINATION" -configuration Release ONLY_ACTIVE_ARCH=NO build | xcpretty;
fi
