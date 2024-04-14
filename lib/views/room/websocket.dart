import 'package:billd_desk_flutter/enum.dart';
import 'package:socket_io_client/socket_io_client.dart' as ws;
import 'package:billd_desk_flutter/utils/index.dart';

class WsClass {
  late ws.Socket socket;

  WsClass() {
    socket = ws.io('wss://srs-pull.hsslive.cn',
        ws.OptionBuilder().setTransports(['websocket']).build());
  }
  init() {
    billdPrint('====init===');
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
}
