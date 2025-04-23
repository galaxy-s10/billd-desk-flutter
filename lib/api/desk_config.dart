import 'package:billd_desk_flutter_pro/utils/request.dart';

class DeskConfigApi {
  static fetchDeskConfigTurnserver() async {
    var res = await HttpRequest.get('/desk_config/turnserver');
    return res;
  }
}
