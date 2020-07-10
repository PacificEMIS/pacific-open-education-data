import 'package:pacific_dashboards/pages/home/home_view_model.dart';
import 'package:pacific_dashboards/service_locator.dart';

class ViewModelFactory {

  static ViewModelFactory _instance;

  static ViewModelFactory get instance {
    if (_instance == null) {
      _instance = ViewModelFactory._();
    }
    return _instance;
  }

  ViewModelFactory._();

  HomeViewModel get home {
    return HomeViewModel(
        globalSettings: serviceLocator.globalSettings,
        remoteConfig: serviceLocator.remoteConfig,
    );
  }
}