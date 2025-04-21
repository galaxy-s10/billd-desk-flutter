import 'dart:ui';

import 'package:billd_desk_flutter_pro/enum.dart';
import 'package:flutter/services.dart';

const localIp = '192.168.1.100';
// const localIp = '10.10.12.4';
const appTitle = 'billd直播';
const themeColor = Color.fromRGBO(255, 215, 0, 1);

// const axiosBaseUrl = 'https://desk-api.hsslive.cn';
// const websocketUrl = 'wss://desk-api.hsslive.cn';
const axiosBaseUrl = 'http://$localIp:5300';
const websocketUrl = 'ws://$localIp:5300';
const axiosTimeoutSeconds = 3;

const normalVideoRatio = 16 / 9;
// 纵横比
const normalAspectRatio = 9 / 16; // 0.5625

const networkErrorMsg = '网络错误';

var liveRoomTypeEnumMap = {
  liveRoomTypeEnum["system"]: 'msr推流',
  liveRoomTypeEnum['obs']: 'obs推流',
  liveRoomTypeEnum['pk']: '打pk',
  liveRoomTypeEnum['srs']: 'srs推流',
  liveRoomTypeEnum['system']: '系统推流',
  liveRoomTypeEnum['tencentcloud_css']: '腾讯云css推流',
  liveRoomTypeEnum['tencentcloud_css_pk']: '腾讯云css打pk',
  liveRoomTypeEnum['wertc_live']: 'webrtc直播',
  liveRoomTypeEnum['wertc_meeting_one']: 'webrtc会议一',
  liveRoomTypeEnum['wertc_meeting_two']: 'webrtc会议二',
  liveRoomTypeEnum['forward_bilibili']: '转推b站',
  liveRoomTypeEnum['forward_huya']: '转推虎牙',
  liveRoomTypeEnum['sforward_all']: '转推所有',
};
