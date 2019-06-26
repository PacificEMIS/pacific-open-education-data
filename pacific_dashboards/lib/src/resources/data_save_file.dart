import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' show Client;

class DataSaveFile {

  static final Client _client = Client();
  static final _baseUrl = "https://fedemis.doe.fm";

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> _localFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.txt');
  }

  static Future<String> _readFile(String key) async {
    try {
      final file = await _localFile(key);

      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  static Future<File> _writeFile(String key, String str) async {
    final file = await _localFile(key);
    _saveTime(key);
    return file.writeAsString(str);
  }

  static Future<bool> _timePassed(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(key + 'time') ?? new DateTime(0).toString();
    DateTime oldDate = DateTime.parse(timeStr);
    final todayDate = DateTime.now();
    final timePass = todayDate.difference(oldDate);
    if (timePass.inHours > 12 || timePass.inMinutes < -5) {
      return true;
    } else{
      return false;
    }
  }

  static Future<bool> _saveTime(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final todayDate = DateTime.now();
    return prefs.setString(key + 'time', todayDate.toString());
  }


  static Future<String> loadFileData(String key) async {
    if (!await DataSaveFile._timePassed(key)) {
      String result = await DataSaveFile._readFile(key);
      return result;
    }

    try {
      final webResponse =
      await _client.get("$_baseUrl/api/warehouse/$key").timeout(
          const Duration(seconds: 20));
      print(webResponse.body.toString());

      if (webResponse.statusCode == 200) {
        await DataSaveFile._writeFile(key, webResponse.body.toString());
        return webResponse.body.toString();
      } else {
        return await DataSaveFile._readFile(key);
      }
    } catch (e) {
      print(e.toString());
      return await DataSaveFile._readFile(key);
    }
  }
}