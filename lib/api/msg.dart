import 'package:billd_desk_flutter_pro/utils/request.dart';

class MsgApi {
  static fetchMsgList(liveRoomId, nowPage, pageSize) async {
    var res = await HttpRequest.get(
      '/msg/list',
      params: {
        'live_room_id': liveRoomId,
        'nowPage': nowPage,
        'pageSize': pageSize,
      },
    );
    return res;
  }
}
