import 'package:billd_desk_flutter_pro/utils/request.dart';

class InviteApi {
  static fetchInviteCreate({uuid, password, roomId}) async {
    var res = await HttpRequest.post(
      '/invite/create',
      data: {'uuid': uuid, 'password': password, 'roomId': roomId},
    );
    return res;
  }
}
