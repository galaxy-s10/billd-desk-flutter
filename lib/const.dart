import 'dart:ui';

const localIp = '192.168.1.103';
const appTitle = 'billd-desk';
const themeColor = Color.fromRGBO(255, 215, 0, 1);

// const axiosBaseUrl = 'https://live-api.hsslive.cn';
// const websocketUrl = 'wss://srs-pull.hsslive.cn';
var axiosBaseUrl = 'http://$localIp:4300';
var websocketUrl = 'ws://$localIp:4300';

const axiosTimeoutSeconds = 5;

const normalVideoRatio = 16 / 9;
