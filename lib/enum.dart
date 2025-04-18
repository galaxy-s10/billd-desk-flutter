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

// 直播间类型
const liveRoomTypeEnum = {
  /** 系统推流 */
  'system': 1,
  /** 主播使用srs推流 */
  "srs": 2,
  /** 主播使用obs/ffmpeg推流 */
  'obs': 3,
  /** 主播使用webrtc推流，直播 */
  'wertc_live': 4,
  /** 主播使用webrtc推流，会议，实现一 */
  'wertc_meeting_one': 5,
  /** 主播使用webrtc推流，会议，实现二 */
  'wertc_meeting_two': 6,
  /** 主播使用msr推流 */
  'msr': 7,
  /** 主播打pk */
  'pk': 8,
  /** 主播使用腾讯云css推流 */
  'tencentcloud_css': 9,
  /** 主播使用腾讯云css推流打pk */
  'tencentcloud_css_pk': 10,
  /** 转推b站 */
  'forward_bilibili': 11,
  /** 转推虎牙 */
  'forward_huya': 12,
  /** 转推斗鱼 */
  'forward_douyu': 13,
  /** 转推斗鱼 */
  'forward_douyin': 14,
  /** 转推斗鱼 */
  'forward_kuaishou': 15,
  /** 转推斗鱼 */
  'forward_xiaohongshu': 16,
  /** 转推所有 */
  'forward_all': 17,
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
};

const clientAppEnum = {
  'billd_live': 'billd_live',
  'billd_live_admin': 'billd_live_admin',
  'billd_desk': 'billd_desk',
  'billd_desk_admin': 'billd_desk_admin',
};
