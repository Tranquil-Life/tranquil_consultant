import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/chat/data/models/position_data.dart';
import 'package:tl_consultant/features/chat/data/repos/audio_player_manager.dart';

class InputBar extends StatelessWidget {
  const InputBar({super.key,
    required this.text,
    required this.isRecording,
    required this.sec,
    required this.showMic,
    required this.draftPath,
    required this.pm,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onDiscardDraft,
    required this.onSendText,
    required this.onSendDraft,
  });

  final TextEditingController text;
  final bool isRecording;
  final int sec;
  final bool showMic;
  final String? draftPath;
  final AudioPlayerManager pm;

  final Future<void> Function() onStartRecording;
  final Future<String?> Function() onStopRecording;
  final Future<void> Function() onDiscardDraft;
  final VoidCallback onSendText;
  final Future<void> Function() onSendDraft;

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildMiddle(context),
              ),
            ),
            const SizedBox(width: 8),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddle(BuildContext context) {
    // 1) While recording: show timer + trash + stop
    if (isRecording) {
      return Row(
        children: [
          const Icon(Icons.mic, color: Colors.red),
          const SizedBox(width: 8),
          Text(_fmt(sec), style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black87),
            onPressed: () async {
              await onStopRecording(); // stop first (no autoplay)
              await onDiscardDraft(); // then discard
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.black87),
            onPressed: () => onStopRecording(),
          ),
        ],
      );
    }

    // 2) WEB: show the blob URL + trash
    if (kIsWeb && draftPath != null) {
      return Row(
        children: [
          const Icon(Icons.audiotrack, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              draftPath!, // blob:... url
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: onDiscardDraft,
            // 👈 clears draft → action button becomes Mic
            tooltip: 'Remove recording',
          ),
        ],
      );
    }

    // 3) NON-WEB: draft mini player
    if (draftPath != null && !kIsWeb) {
      return Row(
        children: [
          StreamBuilder<bool>(
            initialData: false,
            stream: pm.playingStream,
            builder: (_, snap) {
              final playing = snap.data ?? false;
              return IconButton(
                icon: Icon(playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.green),
                onPressed: pm.toggle,
              );
            },
          ),
          Expanded(
            child: StreamBuilder<PositionData>(
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
                  activeColor: ColorPalette.yellow,
                  inactiveColor: ColorPalette.yellow,
                  onChanged: (v) => pm.seek(dur * v),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: onDiscardDraft,
          ),
        ],
      );
    }

    // 4) Default: text input
    return TextField(
      controller: text,
      minLines: 1,
      maxLines: 5,
      decoration: const InputDecoration(
        hintText: 'Type a message...',
        border: InputBorder.none,
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final hasText = text.text.trim().isNotEmpty;
    final hasDraft = draftPath != null;

    // WEB: if a recorded draft exists → SEND; else if typing → SEND; else MIC
    if (kIsWeb) {
      if (hasDraft) {
        return InkWell(
          onTap: onSendDraft, // 👈 uploads + sends URL
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        );
      }

      if (hasText) {
        return InkWell(
          onTap: onSendText,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        );
      }

      return InkWell(
        onTap: onStartRecording,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration:
          const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      );
    }

    // NON-WEB: your existing behavior
    if (showMic && !hasDraft) {
      return InkWell(
        onTap: onStartRecording,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 48,
          height: 48,
          decoration:
          const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: const Icon(Icons.mic, color: Colors.white),
        ),
      );
    }

    return InkWell(
      onTap: hasDraft ? onSendDraft : onSendText,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 48,
        height: 48,
        decoration:
        const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}