import 'dart:async';
import 'dart:io';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/services/formatters.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/audio_player_manager.dart';

class VoiceNoteLayout extends StatefulWidget {
  const VoiceNoteLayout(
      {Key? key, required this.message, required this.playerManager})
      : super(key: key);

  final Message message;
  final AudioPlayerManager playerManager;

  @override
  State<VoiceNoteLayout> createState() => _VoiceNoteLayoutState();
}

class _VoiceNoteLayoutState extends State<VoiceNoteLayout>
    with SingleTickerProviderStateMixin {
  final audioPlayer = AudioPlayer();
  // late AudioPlayer audioPlayer;

  late final AnimationController playAnimController;
  StreamSubscription? _playStateStreamSub;

  final _durTextStream = StreamController<String>.broadcast();

  Stream<String> get onDurationText => _durTextStream.stream;

  bool loadingAudio = true;

  bool isPlaying = false; // Add this variable

  Duration _position = const Duration();
  Duration totalDuration = const Duration(seconds: 0);

  void getAudioDuration(String audioUrl) async {
    // Fetch the audio duration from the URL without playing it
    audioPlayer.setSourceUrl(audioUrl);
    audioPlayer.onDurationChanged.listen((Duration duration) async {
      await Future.delayed(Duration(seconds: 2));

      totalDuration = duration;

      String durationString =
      TimeFormatter.toTimerString(duration.inMilliseconds);
      _durTextStream.add(durationString);
    });

    await preparePlayer();
  }

  getAudioPosition(String audioUrl) async {
    audioPlayer.setSourceUrl(audioUrl);

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
  }

  Future preparePlayer() async {
    setState(() => loadingAudio = false);
    _playStateStreamSub =
        widget.playerManager.audioPlayer.onPlayerStateChanged.listen((event) {
          if (event == PlayerState.paused) {
            playAnimController.reverse();
          } else if (event == PlayerState.playing) {
            playAnimController.forward();
          } else if (event == PlayerState.completed) {
            playAnimController.reverse();
            isPlaying = false;
            widget.playerManager.stop();
          }
        });

    //     audioPlayer.onPlayerStateChanged.listen((event) {
    //   if (event == PlayerState.paused) {
    //     playAnimController.reverse();
    //   } else if (event == PlayerState.playing) {
    //     playAnimController.forward();
    //   }else if(event == PlayerState.completed){
    //     playAnimController.reverse();
    //     isPlaying = false;
    //   }
    // });
  }

  Future<void> playAudio() async {
    setState(() {
      widget.playerManager.play(widget.message.message!);
      audioPlayer.play(UrlSource(widget.message.message!), volume: 0.0);
      isPlaying = true;
    });
  }

  Future<void> pauseAudio() async {
    setState(() {
      widget.playerManager.pause();
      audioPlayer.pause();

      isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    playAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    getAudioDuration(widget.message.message!);

    getAudioPosition(widget.message.message!);
  }

  @override
  void dispose() {
    playAnimController.dispose();
    //audioPlayer.dispose();
    _playStateStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (_) {
                if (loadingAudio) {
                  return SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        const SizedBox.square(
                          dimension: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DottedLine(
                          lineLength: 82,
                          dashColor: widget.message.fromYou
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  );
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isPlaying) {
                          pauseAudio();
                        } else {
                          playAudio();
                        }
                      },
                      child: AnimatedCrossFade(
                        duration: kThemeAnimationDuration,
                        crossFadeState:
                        (isPlaying || widget.playerManager.isPlaying)
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Icon(
                          Icons.play_arrow,
                          color: (widget.message.senderId == myId && widget.message.senderType == consultant) ? ColorPalette.white : ColorPalette.green,
                          size: 28,
                        ),
                        secondChild: Icon(
                          Icons.pause,
                          color: (widget.message.senderId == myId && widget.message.senderType == consultant) ? ColorPalette.white : ColorPalette.green,
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ProgressBar(
                              progress: _position,
                              total: totalDuration,
                              buffered: _position,
                              timeLabelPadding: 0.0,
                              timeLabelTextStyle: const TextStyle(
                                  fontSize: 0, color: Colors.transparent),
                              progressBarColor: ColorPalette.yellow,
                              baseBarColor: Colors.grey[200],
                              bufferedBarColor: Colors.grey[350],
                              thumbColor: Colors.transparent,
                              onSeek: !loadingAudio
                                  ? (duration) async {
                                //await audioPlayer.seek(duration);
                              }
                                  : null,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          //total duration
          const SizedBox(width: 8),
          StreamBuilder<String>(
            initialData: '---:---',
            stream: onDurationText,
            builder: (context, snapshot) {
              return Text(
                snapshot.data!,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.message.fromYou ? Colors.white : Colors.black,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _Slider extends StatefulWidget {
  const _Slider({
    Key? key,
    required this.onValueChanged,
    required this.fromYou,
    required this.value,
  }) : super(key: key);

  final double value;
  final bool fromYou;
  final Function(double value) onValueChanged;

  @override
  State<_Slider> createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  late double value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _Slider oldWidget) {
    setState(() => value = widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 0,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
        thumbColor: widget.fromYou ? Colors.white : Colors.black,
      ),
      child: Slider(
        value: value,
        onChanged: (val) {
          setState(() => value = val);
          widget.onValueChanged(val);
        },
      ),
    );
  }
}
