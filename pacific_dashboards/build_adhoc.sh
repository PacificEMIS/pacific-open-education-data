#!/bin/bash
# fail if any command fails
set -e
# debug log
set -x

./flutterw doctor

./flutterw pub get
./flutterw packages pub run build_runner build --delete-conflicting-outputs

echo 'Building android arm apk'
# ./flutterw -v build apk --release --target-platform=android-arm --dart-define=envApiUser=opendata@pacific-emis.org --dart-define=envApiPassword=iecNp62@7Zkxj2L

./flutterw -v build appbundle --release --dart-define=envApiUser=opendata@pacific-emis.org --dart-define=envApiPassword=iecNp62@7Zkxj2L

echo 'Building iOS ipa'
./flutterw -v build ios --release --no-codesign --dart-define=envApiUser=opendata@pacific-emis.org --dart-define=envApiPassword=iecNp62@7Zkxj2L

echo 'Builds finished'