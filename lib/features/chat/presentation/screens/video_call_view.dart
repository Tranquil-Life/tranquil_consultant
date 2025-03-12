import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/agora_controller.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/call/call_buttons.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({
    Key? key,
    this.onPlatformViewCreated,
    this.onDoubleTap,
    this.isLocal = true,
  }) : super(key: key);

  final bool isLocal;
  final Function()? onDoubleTap;
  final Function(int)? onPlatformViewCreated;

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  final agoraController = Get.put(AgoraController());

  int? _remoteUid;
  RtcEngine? _engine;
  bool onRemoteFace = false;

  bool _localUserJoined = false;

  @override
  void initState() {
    print('Agora Token: ${agoraController.agoraToken.value}');
    print('Agora Room ID: ${agoraController.callRoomId.value}');
 
    initAgora();
    super.initState();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine?.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    setState(() {});

    await Future.delayed(const Duration(seconds: 1));

    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine?.enableVideo();
    await _engine?.startPreview();

    await _engine?.joinChannel(
      token: agoraController.agoraToken.value,
      channelId: agoraController.callRoomId.value,
      uid: userDataStore.user['id'],
      options: const ChannelMediaOptions(),
    );
  }

  Widget _viewBuilder() {
    return _engine != null
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
        : const CircularProgressIndicator(color: ColorPalette.green);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    onRemoteFace = false;
    await _engine?.leaveChannel();
    await _engine?.release();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).padding.deflateSize(displaySize(context));
    final size = Size(0.25 * screenSize.width, 0.2 * screenSize.height);
    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child:
                Center(child: !onRemoteFace ? _remoteVideo() : _viewBuilder()),
          ),
          DraggableWidget(
            topMargin: 48,
            horizontalSpace: 12,
            initialPosition: AnchoringPosition.topRight,
            statusBarHeight: MediaQuery.of(context).viewPadding.top,
            bottomMargin: size.height * 0.8 +
                MediaQuery.of(context).viewPadding.bottom +
                80,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(3),
              child: SizedBox.fromSize(
                size: size,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      onRemoteFace = !onRemoteFace;
                    });
                  },
                  child: !onRemoteFace
                      ? Container(color: Colors.white, child: _viewBuilder())
                      : _remoteVideo(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              color:
                  Colors.black.withOpacity(0.8), // Adjust the opacity as needed
              child: BottomBar(rtcEngine: _engine),
            ),
          ),
        ],
      ),
    ));
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:
              RtcConnection(channelId: agoraController.callRoomId.value),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorPalette.black),
      );
    }
  }
}
