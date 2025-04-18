import 'package:billd_desk_flutter_pro/utils/request.dart';

class LiveRoomApi {
  static getLiveRoomList(params) async {
    var res = await HttpRequest.get('/live_room/list', params: params);
    return res;
  }

  static updateMyLiveRoom(data) async {
    var res =
        await HttpRequest.post('/live_room/update_my_live_room', data: data);
    return res;
  }
}
