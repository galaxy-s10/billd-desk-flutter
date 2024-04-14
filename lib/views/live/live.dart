import 'dart:async';
import 'dart:math';
import 'package:billd_desk_flutter/utils/index.dart';

import 'package:billd_desk_flutter/api/live_api.dart';
import 'package:billd_desk_flutter/api/srs_api.dart';
import 'package:billd_desk_flutter/stores/app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:bruno/bruno.dart';
import 'package:get/get.dart' as get_x;

class WebRTCWidget extends StatefulWidget {
  const WebRTCWidget({super.key});

  @override
  createState() => RTCState();
}

enum LiveStatus { nolive, living }

class RTCState extends State<WebRTCWidget> {
  RTCVideoRenderer? _localRenderer;
  RTCPeerConnection? _pc;
  MediaStream? _stream;
  final Controller store = get_x.Get.put(Controller());

  var mode = [
    {'label': '前置', 'value': 'front'},
    {'label': '后置', 'value': 'back'},
    {'label': '屏幕', 'value': 'screen'},
  ];

  var modeIndex = 0;
  int countdown = 3;
  // var status = ValueNotifier(LiveStatus.nolive);
  var status = LiveStatus.nolive;

  getAllDev() async {
    var res = await navigator.mediaDevices.enumerateDevices();
    for (var element in res) {
      billdPrint(
          'element,${element.kind},${element.label},---${element.deviceId}');
    }
    return res;
  }

  @override
  initState() {
    billdPrint('initState-webrtc');
    super.initState();
    getAllDev();
    // status.addListener(() async {
    //   setState(() {});
    // });
  }

  handleOffer() async {
    // _pc!.addTransceiver(
    //   kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
    //   init: RTCRtpTransceiverInit(direction: TransceiverDirection.SendRecv),
    // );
    // _pc!.addTransceiver(
    //   kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
    //   init: RTCRtpTransceiverInit(direction: TransceiverDirection.SendRecv),
    // );
    try {
      var offer = await _pc!.createOffer({});
      billdPrint('打印offer');
      billdPrint(offer);
      await _pc!.setLocalDescription(offer);
      var liveRoomInfo = store.userInfo['live_rooms'][0];
      billdPrint('offer成功');
      String streamurl =
          '${liveRoomInfo['rtmp_url']}?pushkey=${liveRoomInfo['key']}&pushtype=2';
      var srsres = await SRSApi.getRtcV1Publish(
          api: '/rtc/v1/publish/',
          sdp: offer.sdp,
          streamurl: streamurl,
          tid: Random().nextDouble().toString().substring(2));
      if (srsres['data']['code'] == 400) {
        billdPrint('获取sdp错误');
        if (context.mounted) {
          BrnToast.show('推流错误', context);
        }
        return;
      } else {
        billdPrint('获取sdp成功');
        billdPrint(srsres['data']['sdp']);
      }
      return srsres['data']['sdp'];
    } catch (e) {
      billdPrint(e);
      billdPrint('offer失败');
    }
  }

  handleAnswer(sdp) async {
    try {
      await _pc!.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
      billdPrint('设置远程描述成功');
    } catch (e) {
      billdPrint('设置远程描述失败');
      billdPrint(e);
    }
  }

  handleStream() async {
    MediaStream? stream;
    try {
      if (mode[modeIndex]['value'] == 'front') {
        stream = await navigator.mediaDevices.getUserMedia({
          'video': {
            // 'mandatory': {
            //   'maxWidth': '1280', // 设置最大宽度
            //   'maxHeight': '720', // 设置最大高度
            // },
            'facingMode': 'user', // 指定前置摄像头
          },
          'audio': true,
          'facingMode': 'user', // 指定前置摄像头
        });
      } else if (mode[modeIndex]['value'] == 'back') {
        stream = await navigator.mediaDevices.getUserMedia({
          'video': {
            // 'mandatory': {
            //   'maxWidth': '1280', // 设置最大宽度
            //   'maxHeight': '720', // 设置最大高度
            // },
            'facingMode': 'environment', // 指定后置摄像头
          },
          'audio': true,
        });
      } else if (mode[modeIndex]['value'] == 'screen') {
        stream = await navigator.mediaDevices.getDisplayMedia({
          'video': true,
          'audio': true,
        });

        // try {
        //   bool started = await FlutterScreenRecording.startRecordScreenAndAudio(
        //       'billdtestvideo');
        //   billdPrint('pppppp3,$started');
        // } catch (e) {
        //   billdPrint(e);
        //   billdPrint('pppppp4');
        // }

        // var audiostream = await navigator.mediaDevices.getUserMedia({
        //   'video': false,
        //   'audio': true,
        // });
        // audiostream.getTracks().forEach((track) async {
        //   await _pc?.addTrack(track, audiostream);
        // });
      }
      if (stream != null) {
        stream.getTracks().forEach((track) async {
          billdPrint('pppppp,${track.kind},${track.label}');
          await _pc?.addTrack(track, stream!);
        });
        setState(() {
          _stream = stream;
          _localRenderer!.srcObject = stream;
        });
      }
    } catch (e) {
      billdPrint(e);
      if (context.mounted) {
        BrnToast.show('拒绝授权', context);
      }
    }
  }

  Future<bool> startForegroundService() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Title of the notification',
      notificationText: 'Text of the notification',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    return FlutterBackground.enableBackgroundExecution();
  }

  handleCloseLive() async {
    if (_pc != null) {
      _pc!.close();
      _pc = null;
    }
    if (_stream != null) {
      _stream!.dispose();
      _stream = null;
    }
    if (_localRenderer != null) {
      _localRenderer!.srcObject = null;
      _localRenderer!.dispose();
      _localRenderer = null;
    }
    await LiveApi.getCloseLive();
  }

  handleStartLive() async {
    await startForegroundService();
    _localRenderer = RTCVideoRenderer();
    await _localRenderer!.initialize();
    if (_pc != null) {
      await _pc!.close();
    }
    var res = await LiveApi.getIsLive();
    if (res['data'].length == 0) {
      _pc = await createPeerConnection({
        // 'iceServers': [
        //   {
        //     'urls': 'turn:hsslive.cn:3478',
        //     'username': 'hss',
        //     'credential': '123456',
        //   },
        //   // {
        //   //   'urls': 'stun:stun.l.google.com:19302',
        //   // },
        // ]
        // 'sdpSemantics': "unified-plan" //加不加好像都可以
      });
      await handleStream();
      var sdp = await handleOffer();
      if (sdp != null) {
        handleAnswer(sdp);
        // status.value = LiveStatus.living;
        setState(() {
          status = LiveStatus.living;
        });
      } else {
        if (context.mounted) {
          BrnToast.show('offer错误', context);
        }
      }
    } else {
      if (context.mounted) {
        BrnDialogManager.showConfirmDialog(context,
            title: "提示",
            cancel: '取消',
            confirm: '确定',
            message: "当前正在直播，是否先断开直播？", onConfirm: () async {
          // await LiveApi.getCloseLive();
          await handleCloseLive();
          setState(() {
            status = LiveStatus.nolive;
          });
          if (context.mounted) {
            BrnToast.show('断开直播成功', context);
            Navigator.pop(context, true);
          }
        }, onCancel: () {
          Navigator.pop(context, false);
        });
      }
    }
  }

  @override
  void dispose() {
    // 移除监听订阅
    super.dispose();
    handleCloseLive();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height =
        size.height - kBottomNavigationBarHeight - store.safeHeight.value;

    return Column(
      children: [
        SizedBox(
          height: height - 40,
          width: size.width,
          child: _localRenderer != null
              ? RTCVideoView(
                  _localRenderer!,
                  // mirror: true,
                )
              : null,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 5,
              ),
              const Text("直播方式："),
              BrnRadioButton(
                radioIndex: 0,
                isSelected: modeIndex == 0,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "前置摄像头",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    modeIndex = index;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              BrnRadioButton(
                radioIndex: 1,
                isSelected: modeIndex == 1,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "后置摄像头",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    modeIndex = index;
                  });
                },
              ),
              const SizedBox(
                width: 20,
              ),
              BrnRadioButton(
                radioIndex: 2,
                isSelected: modeIndex == 2,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "屏幕",
                  ),
                ),
                onValueChangedAtIndex: (index, value) {
                  setState(() {
                    modeIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
        // status.value == LiveStatus.nolive
        status == LiveStatus.nolive
            ? BrnBigGhostButton(
                title: '开始直播',
                onTap: () async {
                  BrnDialogManager.showConfirmDialog(context,
                      title: '提示',
                      cancel: '取消',
                      confirm: '确认',
                      message: '是否开播', onConfirm: () async {
                    Navigator.pop(context, true);
                    // BrnLoadingDialog.show(context, content: '$countdown');
                    // Timer.periodic(const Duration(seconds: 1), (timer) {
                    //   setState(() {
                    //     countdown -= 1;
                    //   });
                    //   if (countdown <= 0) {
                    //     timer.cancel();
                    //   }
                    // });
                    await LiveApi.getCloseLive();
                    // await Future.delayed(const Duration(seconds: 3), () {
                    //   BrnLoadingDialog.dismiss(context);
                    //   if (context.mounted) {
                    //     BrnToast.show('直播！', context);
                    //   }
                    // });
                    handleStartLive();
                  }, onCancel: () {
                    Navigator.pop(context, false);
                  });
                },
              )
            : BrnBigGhostButton(
                bgColor: const Color.fromRGBO(244, 67, 54, 0.2),
                titleColor: const Color.fromRGBO(244, 67, 54, 1),
                title: '关闭直播',
                onTap: () {
                  BrnDialogManager.showConfirmDialog(context,
                      barrierDismissible: false,
                      title: '提示',
                      message: '确定关闭直播？',
                      cancel: '取消',
                      confirm: '确定',
                      onCancel: () => {Navigator.pop(context)},
                      onConfirm: () async {
                        await handleCloseLive();
                        setState(() {
                          status = LiveStatus.nolive;
                          BrnToast.show('关闭直播成功', context);
                          Navigator.pop(context);
                        });
                      });
                },
              ),
      ],
    );
  }
}

class Live extends StatelessWidget {
  const Live({super.key});

  @override
  Widget build(BuildContext context) {
    billdRequestPermissions();
    return const SafeArea(
        child: Scaffold(
      body: WebRTCWidget(),
    ));
  }
}
