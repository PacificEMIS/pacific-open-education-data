import 'dart:core';
import "package:collection/collection.dart";

class LookupsModel {
  static const String LOOKUPS_KEY_GOVT = "authorityGovt";
  static const String LOOKUPS_KEY_STATE = "districts";
  static const String LOOKUPS_KEY_AUTHORITY = "authorities";
  static const String LOOKUPS_KEY_NO_KEY = "";

  Map<String, dynamic> _lookupsMap;

  LookupsModel.fromJson(Map parsedJson) {
    _lookupsMap = parsedJson;
  }

  String getFullGovt(String key) {
    return getFullName(key, LOOKUPS_KEY_GOVT);
  }

  String getFullState(String key) {
    return getFullName(key, LOOKUPS_KEY_STATE);
  }

  String getFullAuthority(String key) {
    return getFullName(key, LOOKUPS_KEY_AUTHORITY);
  }

  String getFullName(String key, String type) {
    try {
      if (!_lookupsMap.containsKey(type)){
        return key;
      }
      List dList = _lookupsMap[type];
      for(var val in dList) {
        if (val["C"] == key) {
          return val["N"];
        }
      };
      return key;
    } catch (e) {
      return key;
    }
  }

  toJson() {
    return _lookupsMap;
  }
}
