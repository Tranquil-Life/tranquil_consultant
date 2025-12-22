import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/features/chat/data/models/position_data.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';

class VoiceBubble extends StatelessWidget {
  const VoiceBubble({
    super.key,
    required this.id,
    required this.path,
    required this.fromMe,
    required this.pm,
    required this.activeAudioId,
    this.onBeforePlay,
  });

  final String id;
  final String path;
  final bool fromMe;
  final AudioPlayerManager pm;        // this is the feed/bubbles player
  final RxnString activeAudioId;
  final Future<void> Function()? onBeforePlay;

  bool get _isUrl => path.startsWith('http') || path.startsWith('blob:');

  Future<void> _activateAndPlay() async {
    // Stop draft/other player first, if provided
    if (onBeforePlay != null) await onBeforePlay!();

    activeAudioId.value = id;
    await pm.setSourceSmart(path, isLocal: !_isUrl);
    await pm.play();
  }

  @override
  Widget build(BuildContext context) {
    final color = fromMe ? Colors.white : Colors.black87;

    return Obx(() {
      final isActive = (activeAudioId.value == id);

      final playPause = isActive
          ? StreamBuilder<bool>(
        initialData: pm.isPlaying,
        stream: pm.playingStream,
        builder: (_, s) {
          final playing = s.data ?? false;
          return IconButton(
            icon: Icon(playing ? Icons.pause : Icons.play_arrow, color: color),
            onPressed: () async {
              if (playing) {
                await pm.pause();
              } else {
                if (onBeforePlay != null) await onBeforePlay!();   // ensure focus
                await pm.setSourceSmart(path, isLocal: !_isUrl);    // re-bind
                await pm.play();
              }
            },
          );
        },
      )
          : IconButton(
        icon: Icon(Icons.play_arrow, color: color),
        onPressed: _activateAndPlay,
      );

      final slider = SizedBox(
        width: 160,
        child: isActive
            ? StreamBuilder<PositionData>(
          stream: pm.positionDataStream,
          builder: (_, s) {
            final pos = s.data?.position ?? Duration.zero;
            final dur = s.data?.duration ?? const Duration(seconds: 1);
            final value = dur.inMilliseconds == 0
                ? 0.0
                : pos.inMilliseconds / dur.inMilliseconds;
            return Slider(
              min: 0,
              max: 1,
              value: value.clamp(0.0, 1.0),
              onChanged: (v) => pm.seek(dur * v),
              activeColor: color,
              inactiveColor: fromMe ? Colors.white70 : Colors.black26,
            );
          },
        )
            : const Slider(value: 0, min: 0, max: 1, onChanged: null),
      );

      return Row(mainAxisSize: MainAxisSize.min, children: [playPause, slider]);
    });
  }
}