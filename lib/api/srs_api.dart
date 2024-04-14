import 'package:billd_desk_flutter/api/request.dart';

class SRSApi {
  static getRtcV1Publish({api, sdp, streamurl, tid}) async {
    var res = await HttpRequest.post('/srs/rtcV1Publish', data: {
      'api': api,
      'clientip': null,
      'sdp': sdp,
      'streamurl': streamurl,
      'tid': tid
    });
    return res;
  }
}
