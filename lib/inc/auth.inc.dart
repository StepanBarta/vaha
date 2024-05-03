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


  setServerName(name) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(serverKey, name);
  }

  deleteServerName() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(serverKey);
  }

  getUserName() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString(userNameKey) ?? '';

    return token;
  }

  getUserPass() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString(userPassKey) ?? '';

    return token;
  }

  setUserCredentials(name, pass) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(userNameKey, name);
    await prefs.setString(userPassKey, pass);
  }

  deleteUserCredentials() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(userNameKey);
    prefs.remove(userPassKey);
  }
}
