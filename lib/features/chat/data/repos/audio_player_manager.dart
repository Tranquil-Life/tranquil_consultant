import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/animation.dart';
import 'package:tl_consultant/core/utils/helpers/platform_helpers.dart';
import 'package:tl_consultant/features/chat/data/models/position_data.dart';

class AudioPlayerManager {
  final ap.AudioPlayer _player = ap.AudioPlayer();
  VoidCallback? _onComplete;
  String? _lastPath;
  bool _lastIsLocal = true;
  bool _hasCompleted = false;

  bool _isPlaying = false;

  final _playingCtrl = StreamController<bool>.broadcast();
  final _durationCtrl = StreamController<Duration>.broadcast();
  final _positionCtrl = StreamController<PositionData>.broadcast();

  Stream<bool> get playingStream => _playingCtrl.stream;
  Stream<Duration> get durationStream => _durationCtrl.stream;
  Stream<PositionData> get positionDataStream => _positionCtrl.stream;

  bool get isPlaying => _isPlaying;

  // ✅ keep subscriptions so you can cancel them
  StreamSubscription? _stateSub;
  StreamSubscription? _durSub;
  StreamSubscription? _posSub;
  StreamSubscription? _completeSub;

  bool _disposed = false;

  AudioPlayerManager() {
    _stateSub = _player.onPlayerStateChanged.listen((state) {
      _isPlaying = (state == ap.PlayerState.playing);
      _safeAddPlaying(_isPlaying);
    });

    _durSub = _player.onDurationChanged.listen((d) {
      _safeAddDuration(d);
    });

    _posSub = _player.onPositionChanged.listen((pos) async {
      final dur = await _player.getDuration() ?? Duration.zero;
      _safeAddPosition(PositionData(pos, dur));
      if (dur > Duration.zero && pos < dur) _hasCompleted = false;
    });

    _completeSub = _player.onPlayerComplete.listen((_) {
      _hasCompleted = true;
      _safeAddPlaying(false);
      _onComplete?.call();
    });
  }

  void _safeAddPlaying(bool v) {
    if (_disposed || _playingCtrl.isClosed) return;
    _playingCtrl.add(v);
  }

  void _safeAddDuration(Duration d) {
    if (_disposed || _durationCtrl.isClosed) return;
    _durationCtrl.add(d);
  }

  void _safeAddPosition(PositionData p) {
    if (_disposed || _positionCtrl.isClosed) return;
    _positionCtrl.add(p);
  }

  void onComplete(VoidCallback cb) => _onComplete = cb;


  // ---- PUBLIC API -----------------------------------------------------------

  Future<void> setSourceSmart(String pathOrUrl, {required bool isLocal}) async {
    _lastPath = isLocal ? pathOrUrl : PlatformHelpers.appleSafeUrl(pathOrUrl);
    _lastIsLocal = isLocal;

    if (isLocal) {
      await _player.setSourceDeviceFile(_lastPath!);
    } else {
      await _player.setSourceUrl(_lastPath!);
    }
    _hasCompleted = false;
  }

  Future<void> setSource(String pathOrUrl, {bool isLocal = true}) =>
      setSourceSmart(pathOrUrl, isLocal: isLocal);

  Future<void> play([String? pathOrUrl, bool isLocal = true]) async {
    if (pathOrUrl != null) {
      await setSourceSmart(pathOrUrl, isLocal: isLocal);
    }
    if (_hasCompleted) {
      await _restartFromBeginning();
    } else {
      await _player.resume();
    }
  }

  Future<void> pause() async => _player.pause();
  Future<void> stop() async => _player.stop();
  Future<void> seek(Duration pos) async => _player.seek(pos);

  Future<void> toggle() async {
    if (_isPlaying) {
      await pause();
      return;
    }
    if (_hasCompleted) {
      await _restartFromBeginning();
      return;
    }
    final pos = await _player.getCurrentPosition() ?? Duration.zero;
    final dur = await _player.getDuration() ?? Duration.zero;
    if (dur > Duration.zero && pos >= dur - const Duration(milliseconds: 10)) {
      await _restartFromBeginning();
      return;
    }
    await _player.resume();
  }

  Future<void> _restartFromBeginning() async {
    if (_lastPath == null) return;
    await _player.stop();
    if (_lastIsLocal) {
      await _player.setSourceDeviceFile(_lastPath!);
    } else {
      await _player.setSourceUrl(_lastPath!);
    }
    _hasCompleted = false;
    await _player.resume();
  }

  // ✅ make dispose async so you can await cancellations + player.dispose
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;

    await _stateSub?.cancel();
    await _durSub?.cancel();
    await _posSub?.cancel();
    await _completeSub?.cancel();

    await _player.stop();
    await _player.dispose();

    await _playingCtrl.close();
    await _durationCtrl.close();
    await _positionCtrl.close();
  }
}