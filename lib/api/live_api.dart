import 'package:billd_desk_flutter/api/request.dart';

class LiveApi {
  static getLiveList() async {
    var res = await HttpRequest.get('/live/list', params: {});
    return res;
  }

  static getIsLive() async {
    var res = await HttpRequest.get('/live/is_live', params: {});
    return res;
  }

  static getCloseLive() async {
    var res = await HttpRequest.post('/live/close_live', data: {});
    return res;
  }
}
