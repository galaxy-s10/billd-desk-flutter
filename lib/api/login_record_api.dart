import 'package:billd_desk_flutter_pro/utils/request.dart';

class LoginRecordApi {
  static fetchLoginRecordCreate(data) async {
    var res = await HttpRequest.post('/login_record/create', data: data);
    return res;
  }
}
