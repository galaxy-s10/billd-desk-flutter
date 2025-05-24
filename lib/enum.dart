// websocket消息类型
const wsMsgTypeEnum = {
  'connect': 'connect',

  'changeMaxBitrate': 'changeMaxBitrate',
  'changeMaxFramerate': 'changeMaxFramerate',
  'changeResolutionRatio': 'changeResolutionRatio',
  'changeVideoContentHint': 'changeVideoContentHint',
  'changeAudioContentHint': 'changeAudioContentHint',

  'nativeWebRtcOffer': 'nativeWebRtcOffer',
  'nativeWebRtcAnswer': 'nativeWebRtcAnswer',
  'nativeWebRtcCandidate': 'nativeWebRtcCandidate',

  'join': 'join',
  'joinResult': 'joinResult',
  'keepJoin': 'keepJoin',
  'screenInfo': 'screenInfo',
  'screenInfoResult': 'screenInfoResult',
  'startRemote': 'startRemote',
  'startRemoteResult': 'startRemoteResult',
  'startRtcResult': 'startRtcResult',
  'leaveRemote': 'leaveRemote',
  'leaveRemoteResult': 'leaveRemoteResult',
  'breakRemote': 'breakRemote',
  'billdDeskBehavior': 'billdDeskBehavior',
  'message': 'message',
};

const billdDeskBehaviorEnum = {
  'mouseMove': 'mouseMove',
  'mouseDrag': 'mouseDrag',
  'pressButtonLeft': 'pressButtonLeft',
  'pressButtonRight': 'pressButtonRight',
  'releaseButtonLeft': 'releaseButtonLeft',
  'releaseButtonRight': 'releaseButtonRight',
  'setPosition': 'setPosition',
  'doubleClick': 'doubleClick',
  'leftClick': 'leftClick',
  'rightClick': 'rightClick',
  'scrollDown': 'scrollDown',
  'scrollUp': 'scrollUp',
  'scrollLeft': 'scrollLeft',
  'scrollRight': 'scrollRight',

  'keyboardType': 'keyboardType',
  'keyboardPressKey': 'keyboardPressKey',
  'keyboardReleaseKey': 'keyboardReleaseKey',

  'performDown': 'performDown',
  'performMove': 'performMove',
  'performUp': 'performUp',
  'phoneVolumeUp': 'phoneVolumeUp',
  'phoneVolumeDown': 'phoneVolumeDown',
  'phoneVolumeShow': 'phoneVolumeShow',
  'phoneBackButton': 'phoneBackButton',
  'phoneHomeButton': 'phoneHomeButton',
  'phoneMenuButton': 'phoneMenuButton',
  'phoneScreenLock': 'phoneScreenLock',
  'phoneClipboard': 'phoneClipboard',
};

const clientEnvEnum = {
  'android': 'android',
  'ios': 'ios',
  'ipad': 'ipad',
  'web': 'web',
  'web_mobile': 'web_mobile',
  'web_pc': 'web_pc',
  'windows': 'windows',
  'macos': 'macos',
  'linux': 'linux',
};

const clientAppEnum = {
  'billd_live': 'billd_live',
  'billd_live_admin': 'billd_live_admin',
  'billd_desk': 'billd_desk',
  'billd_desk_admin': 'billd_desk_admin',
};

const lsCacheEnum = {
  'deskUserUuid': 'deskUserUuid',
  'deskUserPassword': 'deskUserPassword',
  'todaylock': 'todaylock',
};
