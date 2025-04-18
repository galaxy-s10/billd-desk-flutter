import 'package:billd_desk_flutter_pro/utils/request.dart';

class AreaApi {
  static getAreaAreaLiveRoomList(params) async {
    var res =
        await HttpRequest.get('/area/area_live_room_list', params: params);
    return res;
  }

  static getAreaLiveRoomList(id, nowPage, pageSize) async {
    var res = await HttpRequest.get('/area/live_room_list',
        params: {'id': id, 'nowPage': nowPage, 'pageSize': pageSize});
    return res;
  }
}
