#!/bin/bash
# fail if any command fails
set -e
# debug log
set -x

flutter channel stable
flutter doctor

flutter pub get

# Build android
flutter -v build apk --release --target-platform=android-arm
# Build ios
# flutter -v build ios --release --no-codesign

cd android
bundle install --path vendor/bundle
bundle exec fastlane distribute
cd ../ios
# sudo bundle exec fastlane distribute

echo 'SUCCESS'

