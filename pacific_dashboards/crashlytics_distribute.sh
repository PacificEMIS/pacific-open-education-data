#!/bin/bash
# fail if any command fails
set -e
# debug log
set -x

flutter channel stable
flutter doctor

flutter pub get

cd lib/l10n
rm -fv *.dart
cd ../..
flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/utils/Localizations.dart 
flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_messages.arb lib/l10n/intl_de.arb lib/l10n/intl_en.arb lib/utils/localizations.dart

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

