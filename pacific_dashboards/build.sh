#!/bin/bash
# fail if any command fails
set -e
# debug log
set -x

./flutterw doctor

./flutterw pub get
./flutterw packages pub run build_runner build

echo 'Building android arm apk'
./flutterw -v build apk --release --target-platform=android-arm

#cd android
#bundle exec fastlane adhoc
#
#cd ..

echo 'Building iOS ipa'
./flutterw -v build ios --release --no-codesign

#cd ios
#bundle exec fastlane adhoc

echo 'Builds finished'