// lib/webrecorder/web_recorder_stub.dart
import 'dart:typed_data';
import 'web_recorder.dart';

class WebRecorderImpl implements WebRecorder {
  @override
  Future<void> start() async {
    throw UnsupportedError('WebRecorder not supported on this platform');
  }

  @override
  Future<String?> stop() async => null;

  @override
  Future<Uint8List?> takeBytes() async => null;

  @override
  String? get lastObjectUrl => null;

  @override
  void dispose() {}
}
