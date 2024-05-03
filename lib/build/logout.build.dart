import 'package:gaubeVaha/inc/auth.inc.dart';
import 'package:gaubeVaha/networking/networking.dart';
import 'package:gaubeVaha/store/store_user.dart';

class LogoutBuild extends Auth with User {
  LogoutBuild();

  logout() async {
    NetworkHelper networkHelper = NetworkHelper(
        module: 'login', action: 'logout', data: {'id': getUserId()});

    var resData = await networkHelper.postData();

    if (resData['status_list'].isNotEmpty) {
      var statusObj = resData['status_list'][0];

      if (statusObj['status'] == 'removed') {
        await deleteAccessToken();
        return true;
      }

      return false;
    }
  }
}
