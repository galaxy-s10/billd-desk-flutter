import 'package:billd_desk_flutter/const.dart';
import 'package:billd_desk_flutter/utils/index.dart';
import 'package:billd_desk_flutter/views/home/websocket.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  WsClass ws = WsClass();

  String wsurl = websocketUrl;

  @override
  initState() {
    super.initState();
    ws.init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('axios：$axiosBaseUrl'),
      Text('wss：$wsurl'),
      GestureDetector(
        child: const Text('send'),
        onTap: () {
          ws.send('join', billdGetRandomString(8), {
            'live_room_id': 123456,
            'socket_id': ws.socket.id,
            'isRemoteDesk': true,
          });
        },
      ),
    ]);
  }
}
