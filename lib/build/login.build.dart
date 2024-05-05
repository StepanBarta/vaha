import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/inc/funkce.inc.dart';
import 'package:gaubeVaha/networking/networking.dart';

class LoginBuild extends Auth {
  LoginBuild( this.userPin );

  final String userPin;

  loginSubmit() async {
    NetworkHelper networkHelper = NetworkHelper(
      module: 'uhk',
      action: 'submit-login',
      data: {
        'pin': userPin
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
      }
print("konec loginu");
      return isLogged;
    } else {
      return false;
    }
  }
}
