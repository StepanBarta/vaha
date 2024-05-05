import 'dart:io';

import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/networking/networking.dart';
import 'package:gaubeVaha/store/store_global.dart';
import 'package:gaubeVaha/store/store_user.dart';

class VerifyUserBuild extends Auth with User {
  VerifyUserBuild();

  verifyUser() async {

//    final serverName = await getServerName();
    final serverName = Global.serverAddress;
    
    if (serverName.isEmpty) return false;

    try {
      NetworkHelper networkHelper = NetworkHelper(
        module: 'uhk',
        action: 'request-verify',
      );

      var resData = await networkHelper.postData();


      if (resData['data'].isNotEmpty &&
          resData['data']['userinfo'].isNotEmpty) {

//        setUserDetail(resData['data']['userinfo']);
//        setIsLogged(true);

//        Global.appVersion = resData['app_version'].toString();

        return true;
      } else {
        setIsLogged(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
