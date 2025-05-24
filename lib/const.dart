import 'dart:ui';
import 'package:flutter/foundation.dart';

// const localIp = '192.168.1.103';
const localIp = '192.168.1.104';
const appTitle = 'BilldDesk';
const themeColor = Color.fromRGBO(255, 215, 0, 1);

const apiUrl =
    kReleaseMode ? 'https://desk-api.hsslive.cn' : 'http://$localIp:5300';
const wssUrl =
    kReleaseMode ? 'wss://desk-api.hsslive.cn' : 'ws://$localIp:5300';

const apiTimeoutSeconds = 8;

const networkErrorMsg = '网络错误';
