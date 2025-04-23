import 'package:billd_desk_flutter_pro/utils/request.dart';

class GlobalMsgGlobalApi {
  static fetchGlobalMsgGlobal({orderName, orderBy, show}) async {
    var res = await HttpRequest.get(
      '/global_msg/global',
      params: {'orderName': orderName, 'orderBy': orderBy, 'show': show},
    );
    return res;
  }
}
