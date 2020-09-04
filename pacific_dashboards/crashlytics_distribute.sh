#!/bin/bash
# fail if any command fails
set -e
# debug log
set -x

./flutterw channel stable
./flutterw doctor

./flutterw pub get

# Build android
./flutterw -v build apk --release --target-platform=android-arm
# Build ios
# ./flutterw -v build ios --release --no-codesign

cd android
bundle install --path vendor/bundle
bundle exec fastlane distribute
cd ../ios
# sudo bundle exec fastlane distribute

echo 'SUCCESS'

