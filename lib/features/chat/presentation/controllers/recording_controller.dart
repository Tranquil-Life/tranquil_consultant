import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart' as av;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class RecordingController extends GetxController {
  static RecordingController get instance => Get.find();

  // final chatController = Get.put(ChatController());

  FlutterSoundRecorder? audioRecorder;
  final RxBool isRecording = false.obs;
  final RxInt recordingDuration = 0.obs; // seconds
  final RxString time = '00:00'.obs;


  String? localAudioPath;
  File? audioFile;
  RxBool isPlaying = false.obs;
  var audioPlayer = AudioPlayer();

  //final _onAudioDuration = StreamController<String>();
  bool recorderInitialize = false;
  bool mPlayerIsInited = false;
  bool mRecorderIsInited = false;
  bool mplaybackReady = false;
  Timer? _timer;

  //android
  // FlutterAudioRecorder2? androidRecorder;
  // Recording? current;
  // RecordingStatus currentStatus = RecordingStatus.Unset;
  // LocalFileSystem localFileSystem = const LocalFileSystem();

  final Codec _codec = Codec.pcm16WAV;

  var uuid = const Uuid();

  String get _mPath => '${uuid.v1().substring(0, 16)}.wav';

  var autoUpload = false.obs;


  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitHours =
    duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours$twoDigitMinutes:$twoDigitSeconds";
  }


  // Future record() async {
  //   try {
  //     if (!recorderInitialize) return;
  //
  //     audioRecorder!.startRecorder(toFile: _mPath, codec: _codec);
  //     isRecording.value = true;
  //     audioRecorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
  //
  //     audioRecorder!.onProgress!.listen((event) async {
  //       time.value = formatDuration(event.duration);
  //       // if (formatDuration(event.duration) == "01:01") {
  //       //   setAutoUpload(autoUpload.value);
  //       // }
  //     });
  //
  //     update();
  //   } catch (e) {
  //     print('Error during recording or uploading: $e');
  //   }
  //
  // }

  void setAutoUpload(bool value) {
    autoUpload.value = !value;
  }

  Future<void> record() async {
    if (!recorderInitialize) return;
    await audioRecorder?.startRecorder(
      // path: use app temp/docs; no storage permission needed
      toFile: 'vn_${DateTime.now().millisecondsSinceEpoch}.aac',
      codec: Codec.aacADTS,
    );
    isRecording.value = true;
    recordingDuration.value = 0; // reset counter
  }

  //Stop recording
  Future stop() async {
    if (!recorderInitialize || !isRecording.value) return;
    localAudioPath = await audioRecorder!.stopRecorder();
    time.value = '00:00';
    isRecording.value = false;
    update();
  }

  //Play recording
  Future<void> onPlayAudio() async {
    update();
    await audioPlayer.play(DeviceFileSource(localAudioPath!));
  }

  Future<void> onStopAudio() async {
    update();
    await audioPlayer.stop();
  }

  startTimer() {
    time.value = '00:00';
    const oneSec = Duration(milliseconds: 500);
    _timer = Timer.periodic(oneSec, (timer) {
      time.value = formatDuration(timer.tick.milliseconds * 500);
      update();
    });
  }

  void stopTimer() {
    _timer!.cancel();
  }

  @override
  void onInit() {
    if(!kIsWeb){
      if (Platform.isIOS) {
        initRecorder();
      } else {
        // initAndroidRecorder();
      }
    }


    super.onInit();
  }


  // @override
  // void onInit() {
  //   super.onInit();
  //
  //   // keep time string in sync
  //   ever<int>(recordingDuration, (sec) {
  //     final m = (sec ~/ 60).toString().padLeft(2, '0');
  //     final s = (sec % 60).toString().padLeft(2, '0');
  //     time.value = '$m:$s';
  //   });
  //
  //   // kick off async init
  //   _init();
  // }

  // Future<void> _init() async {
  //   try {
  //     await initRecorder();
  //   } catch (e) {
  //     debugPrint('Recorder init error: $e');
  //   }
  // }

  // Future<void> initRecorder() async {
  //   if (recorderInitialize) return;
  //
  //   // 1) Mic permission only
  //   final mic = await Permission.microphone.request();
  //   if (mic != PermissionStatus.granted) {
  //     debugPrint('Microphone permission not granted');
  //     return;
  //   }
  //
  //   // 2) Create / open once
  //   audioRecorder ??= FlutterSoundRecorder();
  //   audioPlayer ??= AudioPlayer();
  //
  //   await audioRecorder!.openRecorder();
  //
  //   // 3) Configure audio session
  //   final session = await av.AudioSession.instance;
  //   if (Platform.isIOS) {
  //     await session.configure(av.AudioSessionConfiguration(
  //       avAudioSessionCategory: av.AVAudioSessionCategory.playAndRecord,
  //       avAudioSessionCategoryOptions:
  //       av.AVAudioSessionCategoryOptions.allowBluetooth |
  //       av.AVAudioSessionCategoryOptions.defaultToSpeaker,
  //       avAudioSessionMode: av.AVAudioSessionMode.spokenAudio,
  //       avAudioSessionRouteSharingPolicy:
  //       av.AVAudioSessionRouteSharingPolicy.defaultPolicy,
  //       avAudioSessionSetActiveOptions:
  //       av.AVAudioSessionSetActiveOptions.none,
  //     ));
  //   } else {
  //     // Android: simpler voice comms config
  //     await session.configure(const av.AudioSessionConfiguration(
  //       androidAudioAttributes: av.AndroidAudioAttributes(
  //         contentType: av.AndroidAudioContentType.speech,
  //         usage: av.AndroidAudioUsage.voiceCommunication,
  //         flags: av.AndroidAudioFlags.none,
  //       ),
  //       androidAudioFocusGainType: av.AndroidAudioFocusGainType.gain,
  //       androidWillPauseWhenDucked: true,
  //     ));
  //   }
  //
  //   recorderInitialize = true;
  // }

  ///from master
  void initRecorder() async {
    if (recorderInitialize) return;
    final status = await Permission.microphone.request();
    await Permission.manageExternalStorage.request();

    if (status != PermissionStatus.granted) {
      debugPrint('Microphone permission is not granted');
    }

    audioRecorder = FlutterSoundRecorder();
    audioPlayer = AudioPlayer();
    await audioRecorder!.openRecorder();
    final session = await av.AudioSession.instance;
    await session.configure(av.AudioSessionConfiguration(
      avAudioSessionCategory: av.AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      av.AVAudioSessionCategoryOptions.allowBluetooth |
      av.AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: av.AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      av.AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: av.AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const av.AndroidAudioAttributes(
        contentType: av.AndroidAudioContentType.speech,
        flags: av.AndroidAudioFlags.none,
        usage: av.AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: av.AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    recorderInitialize = true;
  }



  //dispose audio player and recorder
  @override
  void dispose() {
    audioRecorder?.closeRecorder();
    audioPlayer.dispose();

    recorderInitialize = false;

    super.dispose();
  }

///-------/////
// void initAndroidRecorder() async{
//   currentStatus.reactive.value;
//
//   try{
//     bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;
//
//     if (hasPermission) {
//       String customPath = '/${uuid.v1().substring(0, 16)}';
//       Directory appDocDirectory;
//       appDocDirectory = (await getExternalStorageDirectory())!;
//
//       // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//       customPath = appDocDirectory.path +
//           customPath +
//           DateTime.now().millisecondsSinceEpoch.toString();
//
//       // .wav <---> AudioFormat.WAV
//       // .mp4 .m4a .aac <---> AudioFormat.AAC
//       // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//       androidRecorder =
//           FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);
//
//       await androidRecorder!.initialized;
//       // after initialization
//       var current = await androidRecorder!.current(channel: 0);
//       // should be "Initialized", if all working fine
//       //current = current;
//       if(current!.status! != null){
//         currentStatus = current.status!;
//         print("recorder state: $currentStatus");
//       }
//
//     } else {
//       CustomSnackBar.showSnackBar(
//           context: Get.context!,
//           title: "Error",
//           message: "You must accept permissions",
//           backgroundColor: Colors.red);
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// initAndroidRecorder() async {
//   bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;
//   if (hasPermission) {
//     Directory directory;
//     directory = (await getExternalStorageDirectory())!;
//
//     String customPath =
//         directory.path + "/rezme_" + uuid.v1().substring(0, 16).toString();
//
//     androidRecorder = FlutterAudioRecorder2(customPath,
//         audioFormat: AudioFormat.WAV); // or AudioFormat.WAV
//     await androidRecorder?.initialized;
//   } else {
//     CustomSnackBar.showSnackBar(
//         context: Get.context!,
//         title: "Error",
//         message: "You must accept permissions",
//         backgroundColor: Colors.red);
//   }
// }

// start() async {
//   try {
//     await androidRecorder!.start();
//     isRecording.value = true;
//     audioPlayer.dispose();
//     audioPlayer = AudioPlayer();
//     startTimer();
//     // const tick = Duration(milliseconds: 500);
//     // Timer.periodic(tick, (timer) {
//     //   print('timer.tick =${timer.tick}');
//     //   time.value = formatDuration(timer.tick.milliseconds * 500);
//     //   if (recording!.status == RecordingStatus.Stopped) {
//     //     timer.cancel();
//     //   }
//     //   update();
//     // });
//   } catch (e) {
//     print("Error on recording is ${e.toString()}");
//   }
//   //update();
// }



// androidRecorderStop() async {
//   var result = await androidRecorder!.stop();
//   stopTimer();
//   time.value = '00:00';
//   isRecording.value = false;
//   localAudioPath = result!.path;
//   //File file = localFileSystem.file(result!.path);
//   update();
// }


}