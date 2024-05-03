import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/inc/funkce.inc.dart';
import 'package:gaubeVaha/networking/networking.dart';

class LoginBuild extends Auth {
  LoginBuild(this.userName, this.userPass, this.serverName);

  final String userName;
  final String userPass;
  final String serverName;

  loginSubmit() async {
    await setServerName(serverName.trim());

    NetworkHelper networkHelper = NetworkHelper(
      module: 'login',
      action: 'submit',
      data: {
        'name': userName,
        'user_pass': userPass,
        'mobile': 'true',
      },
    );

    final resData = await networkHelper.postData();

    if (resData?['status_list'] != null) {
      final statusObj = resData['status_list'][0];

      notificationAlert(
        message: statusObj['message'],
      );

      final isLogged = statusObj['status'] == 'saved';

      if (isLogged) {
        await setAccessToken(resData['data']);
        await setUserCredentials(userName, userPass);
      } else {
        await deleteUserCredentials();
      }

      return isLogged;
    } else {
      await deleteServerName();
      return false;
    }
  }
}
