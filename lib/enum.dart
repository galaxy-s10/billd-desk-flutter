// websocket消息类型
const wsMsgTypeEnum = {
  /// 用户进入聊天
  'join': 'join',

  /// 用户进入聊天完成
  'joined': 'joined',

  /// 用户进入聊天
  'otherJoin': 'otherJoin',

  /// 用户退出聊天
  'leave': 'leave',

  /// 用户退出聊天完成
  'leaved': 'leaved',

  /// 当前所有在线用户
  'liveUser': 'liveUser',

  /// 用户发送消息
  'message': 'message',

  /// 房间正在直播
  'roomLiving': 'roomLiving',
};
