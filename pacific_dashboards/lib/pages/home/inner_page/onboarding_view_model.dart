import 'package:arch/arch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/configs/global_settings.dart';
import 'package:pacific_dashboards/models/emis.dart';
import 'package:pacific_dashboards/pages/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../res/strings.dart';
import '../home_page.dart';

class OnboardingViewModel extends BaseViewModel {
  final GlobalSettings _globalSettings;

  bool canSelectState = false;
  bool skipWelcomePage = true;
  Emis selectedEmis = null;
  SharedPreferences _sharedPreferences;

  final Subject<Emis> _selectedEmisSubject = BehaviorSubject();

  Stream<Emis> get selectedEmisStream => _selectedEmisSubject.stream;

  SharedPreferences get sharedPreferences => _sharedPreferences;

  OnboardingViewModel(
    BuildContext ctx, {
    @required GlobalSettings globalSettings,
    @required Emis emis,
  })  : assert(globalSettings != null),
        _globalSettings = globalSettings,
        super(ctx);

  @override
  void onInit() {
    super.onInit();
    _selectedEmisSubject.disposeWith(disposeBag);
    _loadCurrentEmis();
  }

  void _loadCurrentEmis() {
    launchHandled(() async {
      final currentEmis = await _globalSettings.currentEmis;
      canSelectState = currentEmis == Emis.fedemis;
      _sharedPreferences = await SharedPreferences.getInstance();
      skipWelcomePage = sharedPreferences.getBool('hideOnboarding') ?? true;
    });
  }

  void onEmisChanged(Emis emis) {
    _globalSettings.setCurrentEmis(emis);
    launchHandled(() async {
      _configureLanguageChanges(emis);
      _selectedEmisSubject.add(emis);
    });
  }

  void onSkipWelcomePageChanged(bool isSkip) {
    skipWelcomePage = isSkip;
    sharedPreferences.setBool('hideOnboarding', skipWelcomePage);
  }
  void onContinuePressed(BuildContext context) {
    sharedPreferences.setBool('hideOnboarding', skipWelcomePage);
    Navigator.of(context).pushNamed(
      HomePage.kRoute,
    );
  }

  void _configureLanguageChanges(Emis currentEmis) {
    Strings.emis = currentEmis;
  }
}
