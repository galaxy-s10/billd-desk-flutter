import 'package:billd_desk_flutter_pro/utils/index.dart';
import 'package:billd_desk_flutter_pro/utils/request.dart';

class UserApi {
  static idLogin({required int id, required String password}) async {
    var res = await HttpRequest.post(
      '/user/login',
      data: {'id': id, 'password': password},
    );
    return res;
  }

  static usernameLogin({
    required String username,
    required String password,
  }) async {
    var res = await HttpRequest.post(
      '/user/username_login',
      data: {'username': username, 'password': password},
    );
    return res;
  }

  static getUserInfo() async {
    var res = await HttpRequest.get('/user/get_user_info', params: {});
    return res;
  }

  static fetchDeskUserCreate() async {
    var res = await HttpRequest.post('/desk_user/create');
    return res;
  }

  static fetchDeskUserLogin({uuid, password}) async {
    var res = await HttpRequest.post(
      '/desk_user/login',
      data: {'uuid': uuid, 'password': password},
    );
    return res;
  }

  // ignore: non_constant_identifier_names
  static fetchDeskUserUpdateByUuid({uuid, password, new_password}) async {
    billdPrint(uuid);
    billdPrint(password);
    billdPrint(new_password);
    var res = await HttpRequest.put(
      '/desk_user/update_by_uuid',
      data: {'uuid': uuid, 'password': password, 'new_password': new_password},
    );
    return res;
  }
}
