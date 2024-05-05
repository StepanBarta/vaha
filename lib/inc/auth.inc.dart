import 'package:gaubeVaha/store/store_global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const tokenKey = 'access-token';
  static const serverKey = 'server-name';
  static const userNameKey = 'username';
  static const userPassKey = 'userpass';

  getAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString(tokenKey) ?? '';

    return token;
  }

  setAccessToken(cvalue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(tokenKey, cvalue);
  }

  deleteAccessToken() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(tokenKey);
  }

  getServerName() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString(serverKey) ?? '';

    return token;
  }


  getServerName2() async {
    return Global.serverAddress;
  }

}
