import 'package:billd_desk_flutter/api/request.dart';

class LiveRoomApi {
  static getLiveRoomList(params) async {
    var res = await HttpRequest.get('/live_room/list', params: params);
    return res;
  }
}
