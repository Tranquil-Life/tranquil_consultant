// Only compiled on web.
import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;

import 'web_recorder.dart';

class WebRecorderImpl implements WebRecorder {
  html.MediaRecorder? _rec;
  html.MediaStream? _stream;
  final List<html.Blob> _chunks = [];
  html.Blob? _lastBlob;
  String? _lastUrl;

  // Preview UI elements
  html.DivElement? _previewWrap;
  html.AudioElement? _previewEl;
  html.ButtonElement? _closeBtn;

  @override
  Future<void> start() async {
    final mediaDevices = html.window.navigator.mediaDevices;
    _stream = await mediaDevices?.getUserMedia({'audio': true});

    var mime = 'audio/webm';
    if (!html.MediaRecorder.isTypeSupported(mime) &&
        html.MediaRecorder.isTypeSupported('audio/mp4')) {
      mime = 'audio/mp4';
    }

    _rec = html.MediaRecorder(_stream!, {'mimeType': mime});
    _chunks.clear();

    _rec!.addEventListener('dataavailable', (html.Event e) {
      final ev = e as html.BlobEvent;
      if (ev.data != null) _chunks.add(ev.data!);
    });

    _rec!.addEventListener('stop', (html.Event e) {
      _lastBlob = html.Blob(_chunks, mime);
      _lastUrl = html.Url.createObjectUrl(_lastBlob!);
      _showPreview(_lastUrl!); // ⬅️ show preview with close button
    });

    _rec!.start();
  }

  @override
  Future<String?> stop() async {
    if (_rec == null) return _lastUrl;
    final c = Completer<void>();
    void onStopped(html.Event _) {
      _rec!.removeEventListener('stop', onStopped);
      c.complete();
    }
    _rec!.addEventListener('stop', onStopped);

    _rec!.stop();
    _stream?.getTracks().forEach((t) => t.stop());
    _stream = null;

    await c.future;
    return _lastUrl;
  }

  @override
  String? get lastObjectUrl => _lastUrl;

  @override
  Future<Uint8List?> takeBytes() async {
    final b = _lastBlob;
    if (b == null) return null;
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();
    reader.readAsArrayBuffer(b);
    reader.onLoadEnd.listen((_) => completer.complete(reader.result as Uint8List));
    reader.onError.listen((e) => completer.completeError(e));
    return completer.future;
  }

  /// Public: let Flutter close the preview programmatically
  void closePreview() => _removePreview();

  void _showPreview(String url) {
    // Reuse wrapper if present
    _previewWrap ??= html.DivElement()
      ..style.cssText = '''
        position: fixed;
        left: 12px; bottom: 12px;
        z-index: 2147483647;
        display: flex; align-items: center; gap: 8px;
        background: #ffffff; border-radius: 8px;
        box-shadow: 0 6px 20px rgba(0,0,0,.18);
        padding: 8px 8px 8px 12px;
        font-family: system-ui, -apple-system, Arial, sans-serif;
      ''';

    _previewEl ??= html.AudioElement()
      ..controls = true
      ..autoplay = true
      ..style.width = '260px';

    if (_previewEl!.src != url) {
      _previewEl!
        ..src = url
        ..autoplay = true;
    }

    _closeBtn ??= html.ButtonElement()
      ..text = '✕'
      ..title = 'Close preview'
      ..style.cssText = '''
        border: none; background: #f3f4f6; color: #111827;
        width: 28px; height: 28px; border-radius: 6px; cursor: pointer;
      ''';
    _closeBtn!.onClick.listen((_) => _removePreview());

    _previewWrap!
      ..children = [_previewEl!, _closeBtn!];

    if (_previewWrap!.parent == null) {
      html.document.body!.append(_previewWrap!);
    }
  }

  void _removePreview() {
    _previewEl?.pause();
    _previewEl?.src = '';
    _previewWrap?.remove();
    _previewWrap = null;
    _previewEl = null;
    _closeBtn = null;
  }

  @override
  void dispose() {
    if (_lastUrl != null) {
      html.Url.revokeObjectUrl(_lastUrl!);
      _lastUrl = null;
    }
    _removePreview();
    _stream?.getTracks().forEach((t) => t.stop());
    _stream = null;
    _rec = null;
  }
}
