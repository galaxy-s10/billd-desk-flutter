import 'dart:convert';
import 'dart:io';
import 'dart:math';

class BilldSrsSdk {
  // WARN 注意，https的时候，不能带1985端口
  // http://tm0.net:1985
  // srs的http api地址
  final String api;
  BilldSrsSdk({required this.api});

  static debugLog(e) {
    print('===BilldSrsSdk===');
    print(e);
  }

  Future<String?> push({required String streamurl, required String sdp}) async {
    var anwser;
    try {
      var httpClient = HttpClient();
      var url = Uri.parse('$api/rtc/v1/publish/');
      final requestBody = {
        'api': '/rtc/v1/publish/',
        'sdp': sdp,
        'streamurl': streamurl,
        'tid': Random().nextDouble().toString().substring(2)
      };
      httpClient.connectionTimeout = const Duration(seconds: 5);
      httpClient.idleTimeout = const Duration(seconds: 5);
      var httpreq = await httpClient.postUrl(url);
      httpreq.headers.add('Content-Type', 'application/json');
      httpreq.write(jsonEncode(requestBody));
      var httpres = await httpreq.close();
      final respBody = await httpres.transform(utf8.decoder).join();
      final resp = jsonDecode(respBody);
      anwser = resp['sdp'];
    } catch (e) {
      debugLog(e);
    }
    return anwser;
  }
}

var sdk = BilldSrsSdk(api: '');
