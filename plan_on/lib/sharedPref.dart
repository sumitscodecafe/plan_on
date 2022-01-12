import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref _sharedPref;
  static SharedPreferences _preferences;


  static Future<SharedPref> getInstance() async {
    if (_sharedPref == null) {
      var secureStorage = SharedPref._();
      await secureStorage._init();
      _sharedPref = secureStorage;
    }
    return _sharedPref;
  }

  SharedPref._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  static String getString(String key, {String defValue = "0"}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }

  static Future<bool> clrString() {
    SharedPreferences prefs = _preferences;
    prefs.clear();
  }
}