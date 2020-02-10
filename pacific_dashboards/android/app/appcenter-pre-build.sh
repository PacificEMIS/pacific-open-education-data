#!/bin/bash
cd lib/l10n/
rm -fv *.dart
cd ../../..
flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n /Users/mac/pacific-dashboards/pacific_dashboards/lib/utils/Localizations.dart 
flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_messages.arb lib/l10n/intl_de.arb lib/l10n/intl_en.arb lib/utils/localizations.dart