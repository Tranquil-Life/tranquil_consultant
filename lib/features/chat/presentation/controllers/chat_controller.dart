import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
import 'package:tl_consultant/core/utils/extensions/chat_message_extension.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/screens/incoming_call_view.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';
import 'package:vibration/vibration.dart';

class ChatController extends GetxController {
  static ChatController instance = Get.find();

  final dashboardController = Get.put(DashboardController());

  ChatRepoImpl repo = ChatRepoImpl();

  RxList<Message> messages = <Message>[].obs;

  File? audioFile;
  late PusherChannel myChannel;

  var callRoomId = "".obs;
  RxSet<int> remoteIds = <int>{}.obs;
  var agoraToken = "".obs;
  String val = uidGenerator.v4();

  var loadingChatRoom = false.obs;
  RxBool isExpanded = false.obs;
  RxString messageType = MessageType.text.toString().obs;
  RxInt? chatId;
  var chatChannel = "".obs;
  Rx<Message> replyMessage = Message().obs;
  Rx<Message> recentMsgEvent = Message().obs;

  // Used to display loading indicators when _firstLoad function is running
  var lastMessageId = 0.obs;
  var isFirstLoadRunning = false.obs;

  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  RxBool allPagesLoaded = false.obs; // Flag to check if all pages are loaded


  //recent messages
  Future loadRecentMessages() async {
    if (chatId != null) {
      isFirstLoadRunning.value = true;
      var result = await repo.getRecentMessages(chatId: chatId!.value);

      result.fold((l) {}, (r) {
        messages.clear();

        var data = r['data'];

        for (int i = 0; i < (data as List).length; i++) {
          Message message = MessageModel.fromJson(data[i]);
          messages.add(message);
        }

        if (messages.isNotEmpty) {
          lastMessageId.value = messages[messages.length - 1].messageId!;
        } else {
          isFirstLoadRunning.value = false;
        }
      });

      update();
      isFirstLoadRunning.value = false;
      // Additional logic related to chatId...
    }
  }

  Future loadOlderMessages() async {
    isLoadMoreRunning.value = true;

    List<Message> newMessages = <Message>[];

    var result = await repo.getOlderMessages(
      chatId: chatId!.value,
      lastMessageId: lastMessageId.value,
    );

    result.fold((l) {}, (r) {
      var data = r['data'];
      for (int i = 0; i < (data as List).length; i++) {
        Message message = MessageModel.fromJson(data[i]);
        newMessages.add(message);
      }

      if (newMessages.isNotEmpty) {
        lastMessageId.value = newMessages[newMessages.length - 1].messageId!;

        messages.addAll(newMessages);
      } else {
        isLoadMoreRunning.value = false;
      }
    });

    update();
    isLoadMoreRunning.value = false;
  }
  //Get specific chat history
  Future getChatInfo({ClientUser? client}) async {
    loadingChatRoom.value = true;
    Either either = await repo.getChatInfo(
      consultantId: userDataStore.user['id'],
      clientId: dashboardController.clientId.value,
      meetingId: dashboardController.currentMeetingId.value
    );

    Map chatInfo = {};

    either.fold((l) {
      loadingChatRoom.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      chatInfo = r['data'];


      chatId ??= RxInt(0);
      chatId!.value = chatInfo['id'];
      chatChannel.value = chatInfo['channel'];
      dashboardController.clientId.value = chatInfo['client']['id'];
      dashboardController.clientName.value = chatInfo['client']['display_name'];
      dashboardController.clientDp.value = chatInfo['client']['avatar_url'];
    });

    Get.toNamed(
      Routes.CHAT_SCREEN,
      arguments: <String, dynamic>{
        "chat_id": chatId?.value,
        "client": client,
        "channel": chatChannel.value
      },
    );


    await Future.delayed(const Duration(seconds: 1));

    loadRecentMessages();

    loadingChatRoom.value = false;

    return chatInfo;
  }

  setVoiceFile(File file) {
    audioFile = file;
    update();
  }

  void addMessage(Message message) {
    messages.add(message);
    messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    // Optionally scroll to bottom if needed
  }

  Future initializePusher({required String channel}) async {
    try {
      myChannel = PusherChannel(channelName: channel);
      await pusher.init(
        apiKey: AppConfig.pusherKey,
        cluster: 'eu',
        onConnectionStateChange: (dynamic currentState, dynamic previousState) {},
        onError: (String message, int? code, dynamic e) {
          // print("onError: $message code: $code exception: $e");
        },
        onSubscriptionSucceeded: (channelName, data) {

        },
        onEvent: (PusherEvent event) async {
          print("Received event: ${event.eventName}, data: ${event.data}");

          var eventData = Map<String, dynamic>.from(jsonDecode(event.data));

          if (eventData.containsKey('message')) {
            final message = MessageModel.fromJson(eventData['message']);

            if (event.eventName == 'incoming-call') {
              if (!message.fromYou) {
                // Trigger call UI or logic
                handleIncomingCall(message);

                var hasVibrator = await Vibration.hasVibrator();
                if (hasVibrator) {
                  await Vibration.vibrate(duration: 3000, amplitude: 225);
                }
              }
            } else {
              recentMsgEvent.value = message;

              if (!message.fromYou) {
                await Future.delayed(Duration(seconds: 1));
                addMessage(message);
              }

              // print("Event '${event.eventName}' received with message ID: ${message.messageId}");
            }
          }
          else {
            // print("Missing 'message' in event data.");
          }
        },
        onSubscriptionError: (String message, dynamic e) {
        },
        onDecryptionFailure: (String event, String reason) {
          // print("onDecryptionFailure: $event reason: $reason");
        },
        onMemberAdded: (String channelName, PusherMember member) {
          // print("onMemberAdded: $channelName member: $member");
        },
        onMemberRemoved: (String channelName, PusherMember member) {
          // print("onMemberRemoved: $channelName member: $member");
        },
      );

      //subscribe to the chat channel
      enterChatRoom(channel);

      await pusher.connect();
    } catch (e) {
      // print("ERROR: $e");
    }
  }

  void enterChatRoom(channel) async{
    myChannel = await pusher.subscribe(channelName: channel);
  }

  void leaveChatRoom() {
    myChannel.unsubscribe();
  }

  Future triggerPusherEvent(eventName, data) async {
    Either either = await repo.triggerPusherEvent(
      myChannel.channelName,
      eventName,
      data,
    );
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      //..
    });
  }

  void handleIncomingCall(MessageModel message) {
    Get.to(
      IncomingCallView(
        clientId: dashboardController.clientId.value,
        clientName: dashboardController.clientName.value,
        clientDp: dashboardController.clientDp.value,
      ),
    );
  }

  @override
  void onInit() {
    loadRecentMessages();
    super.onInit();
  }

  @override
  void onClose() {
    // isExpanded.value = false;
    // chatId!.close(); // Dispose of the subscription

    super.onClose();
  }
}


