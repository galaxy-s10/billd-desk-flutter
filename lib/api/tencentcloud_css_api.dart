import 'package:billd_desk_flutter_pro/utils/request.dart';

class TencentcloudCssApi {
  static push(int liveRoomId) async {
    var res = await HttpRequest.post('/tencentcloud_css/push',
        data: {'liveRoomId': liveRoomId});
    return res;
  }

  static pushstream({sdp, streamurl, sessionid}) async {
    var res = await HttpRequest.post(
        'https://webrtcpush.myqcloud.com/webrtc/v1/pushstream',
        data: {
          'clientinfo': 'macOS 10.15.7;Chrome 128.0.0.0',
          'clienttype': 'TXLivePusher-2.1.1',
          'localsdp': {'sdp': sdp, "type": 'offer'},
          'metadata': {'audiodatarate': 40, 'videodatarate': 1500},
          'sessionid': sessionid,
          'streamurl': streamurl
        });
    return res;
  }
}
