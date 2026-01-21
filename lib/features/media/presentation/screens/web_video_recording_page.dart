import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;

class WebVideoRecordingPage extends StatefulWidget {
  final Duration maxDuration;

  const WebVideoRecordingPage({super.key, required this.maxDuration});

  @override
  State<WebVideoRecordingPage> createState() => _WebVideoRecordingPageState();
}

class _WebVideoRecordingPageState extends State<WebVideoRecordingPage> {
  html.VideoElement? _videoElement;
  html.MediaStream? _mediaStream;
  html.MediaRecorder? _mediaRecorder;
  final List<html.Blob> _chunks = [];
  bool _isRecording = false;

  // Timer variables
  int _secondsRemaining = 0;
  Timer? _countdownTimer;

  String _viewId = 'video-preview-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.maxDuration.inSeconds;
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      ui_web.platformViewRegistry
          .registerViewFactory(_viewId, (int viewId) => _videoElement!);

      _mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({
        'video': {'width': 1280, 'height': 720},
        'audio': true,
      });

      _videoElement!.srcObject = _mediaStream;
      setState(() {});
    } catch (e) {
      debugPrint('Error accessing camera: $e');
    }
  }

  void _startRecording() {
    if (_mediaStream == null) return;

    _chunks.clear();
    _mediaRecorder = html.MediaRecorder(_mediaStream!);

    // 1. Use the generic 'on' property with the event name 'dataavailable'
    _mediaRecorder!.on['dataavailable'].listen((html.Event event) {
      // 2. Cast the generic event to a BlobEvent to access the .data property
      final blobEvent = event as html.BlobEvent;
      if (blobEvent.data != null) {
        _chunks.add(blobEvent.data!);
      }
    });

    // 3. Do the same for the 'stop' event
    _mediaRecorder!.on['stop'].listen((_) => _processAndReturnVideo());

    _mediaRecorder!.start();

    // Start the countdown timer
    _secondsRemaining = widget.maxDuration.inSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopRecording();
        }
      });
    });

    setState(() => _isRecording = true);
  }

  void _stopRecording() {
    if (_mediaRecorder != null && _isRecording) {
      _mediaRecorder!.stop();
      _countdownTimer?.cancel();
      setState(() => _isRecording = false);
    }
  }

  Future<void> _processAndReturnVideo() async {
    final blob = html.Blob(_chunks, 'video/webm');
    final reader = html.FileReader();

    reader.readAsArrayBuffer(blob);
    await reader.onLoadEnd.first;

    // 1. Get the result as a generic object
    final Object? result = reader.result;
    late Uint8List videoBytes;

    // 2. Safely handle whether it's a ByteBuffer or already a Uint8List
    if (result is ByteBuffer) {
      videoBytes = result.asUint8List();
    } else if (result is Uint8List) {
      videoBytes = result;
    } else {
      // This fallback handles edge cases where the result might be null or unexpected
      videoBytes = Uint8List(0);
      debugPrint("Warning: FileReader result was an unexpected type: ${result.runtimeType}");
    }

    // 3. Stop all hardware tracks (releases camera/mic)
    _mediaStream?.getTracks().forEach((track) => track.stop());

    if (mounted) {
      Navigator.of(context).pop(videoBytes);
    }
  }
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _mediaStream?.getTracks().forEach((track) => track.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Native Video Preview
          _videoElement != null
              ? HtmlElementView(viewType: _viewId)
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white)),

          // 2. Top Navigation & Timer Overlay
          Positioned(
            top: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isRecording) _buildPulseIndicator(),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(_secondsRemaining),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Close Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // 4. Record Button (Bottom)
          Positioned(
            bottom: 50,
            child: GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                  // Inner button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isRecording ? 30 : 60,
                    height: _isRecording ? 30 : 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                          BorderRadius.circular(_isRecording ? 5 : 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseIndicator() {
    return const _PulsingDot();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }
}

// Simple internal widget for the pulsing red dot
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 12,
        height: 12,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }
}
