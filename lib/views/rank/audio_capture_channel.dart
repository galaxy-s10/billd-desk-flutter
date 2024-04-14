import 'package:flutter/services.dart';

class AudioCaptureChannel {
  static const MethodChannel _methodChannel =
      MethodChannel('audio_capture_channel');

  static Future<void> startAudioCapture() async {
    await _methodChannel.invokeMethod('startAudioCapture');
  }

  static Future<void> stopAudioCapture() async {
    await _methodChannel.invokeMethod('stopAudioCapture');
  }

  static void setAudioDataHandler(Function(List<int>) handler) {
    _methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onAudioData') {
        final List<int> audioData = List<int>.from(call.arguments);
        handler(audioData);
      }
    });
  }
}
