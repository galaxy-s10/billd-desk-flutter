import 'package:billd_desk_flutter/api/request.dart';

class UserApi {
  static login({required int id, required String password}) async {
    var res = await HttpRequest.post('/user/login',
        data: {'id': id, 'password': password});
    return res;
  }

  static getUserInfo() async {
    var res = await HttpRequest.get('/user/get_user_info', params: {});
    return res;
  }
}
