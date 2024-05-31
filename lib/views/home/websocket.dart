import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/enum.dart';
import 'package:billd_desk_flutter/utils/index.dart';
import 'package:socket_io_client/socket_io_client.dart' as ws;

class WsClass {
  late ws.Socket socket;

  // WsClass() {}

  init() {
    socket = ws.io(
        websocketUrl, ws.OptionBuilder().setTransports(['websocket']).build());
    billdPrint('===init===$websocketUrl');
    socket.onConnect((data) {
      billdPrint('===onConnect===,$data,${socket.id}');
    });
    socket.on(wsMsgTypeEnum['message']!, (data) {
      billdPrint('===message===,$data');
      billdPrint(data);
    });
    socket.onDisconnect((_) {
      billdPrint('===onDisconnect===');
      billdPrint(_);
    });
    socket.on('fromServer', (_) {
      billdPrint('===fromServer===');
      billdPrint(_);
    });
  }

  send(String msgType, String requestId, dynamic data) {
    billdPrint('===send===');
    // request_id: requestId,
    // socket_id: this.socketIo.id,
    // is_anchor: this.isAnchor,
    // user_info: userStore.userInfo,
    // user_token: userStore.token || undefined,
    // data: data || {},
    var sendData = {
      'request_id': requestId,
      'socket_id': socket.id,
      'is_anchor': false,
      'data': data
    };
    socket.emit(msgType, sendData);
  }
}
