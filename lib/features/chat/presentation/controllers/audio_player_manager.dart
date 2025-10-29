// Class responsible for managing audio playback
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  late final AudioPlayer audioPlayer;
  late bool _isPlaying;


  AudioPlayerManager() {
    audioPlayer = AudioPlayer();
    _isPlaying = false;
  }

  bool get isPlaying => _isPlaying;

  void play(String audioUrl) async {
    if (audioPlayer != null) {
      stop();
    }

    await audioPlayer.setSourceUrl(audioUrl);
    await audioPlayer.play(UrlSource(audioUrl));
    _isPlaying = true;
  }

  void pause() async {
    await audioPlayer.pause();
    _isPlaying = false;
  }

  void stop() async {
    await audioPlayer.stop();
    _isPlaying = false;
  }
}
