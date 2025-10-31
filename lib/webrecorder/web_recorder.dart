// Platform-agnostic API the screen can call.
import 'dart:typed_data';

abstract class WebRecorder {
  Future<void> start();
  Future<String?> stop();            // returns blob: URL on web, null elsewhere
  String? get lastObjectUrl;         // blob: URL on web
  Future<Uint8List?> takeBytes();    // blob bytes on web
  void dispose();
}
