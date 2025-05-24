import 'package:billd_desk_flutter_pro/utils/request.dart';

class WsApi {
  static getWsInfo() async {
    var res = await HttpRequest.get('/ws/get_ws_info');
    return res;
  }

  static fetchWsKeepAlive({deskUserUuid, inviteId, roomId, socketId}) async {
    var res = await HttpRequest.post(
      '/ws/keep_alive',
      data: {
        'deskUserUuid': deskUserUuid,
        'inviteId': inviteId,
        'roomId': roomId,
        'socketId': socketId,
      },
    );
    return res;
  }

  static fetchWsSendMsg(data) async {
    var res = await HttpRequest.post('/ws/send_msg', data: data);
    return res;
  }
}
