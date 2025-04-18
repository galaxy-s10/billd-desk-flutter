import 'package:billd_desk_flutter_pro/utils/request.dart';

class LiveApi {
  static getLiveList() async {
    var res = await HttpRequest.get('/live/list', params: {});
    return res;
  }

  static getIsLive() async {
    var res = await HttpRequest.get('/live/is_live');
    return res;
  }

  static getCloseMyLive() async {
    var res = await HttpRequest.post('/live/close_my_live', data: {});
    return res;
  }

  static startLive(data) async {
    var res = await HttpRequest.post('/live/start_live', data: data);
    return res;
  }

  static getliveRoomOnlineUser(roomId) async {
    var res = await HttpRequest.get('/live/live_room_online_user/$roomId');
    return res;
  }
}
