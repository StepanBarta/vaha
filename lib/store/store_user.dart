// import 'dart:html';

// import 'package:pivaris3mob/store/store_global.dart';

class User {
  // static String accessToken = '';
  static dynamic _isUserLogged;
  static Map<String, dynamic> _userDetail = {};

  getIsUserLogged() {
    return _isUserLogged;
  }

  getUserId() {
    return _userDetail['id'];
  }

  setUserDetail(Map<String, dynamic> data) {
    _userDetail = data;
  }

  setIsLogged(bool isLogged) {
    _isUserLogged = isLogged;
  }

  /* getAccessToken() {
    return Global.accessToken;
    // try {
    //   var cookie = '; ${document.cookie}';
    //   var splitCookie = cookie.split('; p3mobb=');

    //   if (splitCookie.length == 2) {
    //     var token = splitCookie[1];
    //     return token != '' ? token : '';
    //   } else {
    //     return '';
    //   }
    // } catch (e) {
    //   return '';
    // }
  } */

  /* setAccessToken(cvalue) {
    if (cvalue.isEmpty) return;

    DateTime today = DateTime.now();
    var newDate = DateTime(today.year, today.month + 1, today.day);
    var expires = 'expires=${newDate.toIso8601String()}';

    document.cookie = 'p3mobb=$cvalue;$expires;path=/';
  } */

  /* deleteAccessToken() {
    if (getAccessToken() != '') {
      document.cookie = 'p3mobb=;path=/;expires=Thu, 01 Jan 1970 00:00:01 GMT';
    }
  } */
}
