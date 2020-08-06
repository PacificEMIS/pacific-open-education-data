import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pacific_dashboards/res/strings/l10n/messages_all.dart';

// flutter pub run intl_translation:extract_to_arb --output-dir=lib/res/strings/l10n lib/res/strings/strings.dart
// edit translations
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/res/strings/l10n --no-use-deferred-loading lib/res/strings/strings.dart lib/res/strings/l10n/intl_en.arb

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String get individualSchoolFlowHistoryTableDomainTitle =>
      Intl.message('GR',
          name: 'individualSchoolFlowHistoryTableDomainTitle');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'he'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
