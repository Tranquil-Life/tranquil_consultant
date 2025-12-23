import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:js_util' as js_util;
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

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
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/chat/data/models/message_model.dart';
import 'package:tl_consultant/features/chat/data/repos/chat_repo.dart';
import 'package:tl_consultant/features/chat/domain/entities/message.dart';
import 'package:tl_consultant/features/chat/presentation/screens/incoming_call_view.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';
import 'package:vibration/vibration.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find<ChatController>();

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
  Rx<ClientUser> rxClient = ClientUser().obs;

  // Used to display loading indicators when _firstLoad function is running
  var lastMessageId = 0.obs;
  var isFirstLoadRunning = false.obs;

  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  RxBool allPagesLoaded = false.obs; // Flag to check if all pages are loaded

  //recent messages
  Future loadRecentMessages() async {
    final cid = chatId?.value;
    if (cid == null || cid == 0) return;

    isFirstLoadRunning.value = true;
    allPagesLoaded.value = false;

    final result = await repo.getRecentMessages(chatId: cid);

    result.fold((l) {
      // handle error if you want
    }, (r) {
      messages.clear();

      final data = r['data'];
      if (data is! List) return;

      for (final item in data) {
        messages.add(MessageModel.fromJson(item));
      }

      final cursor = lastNonNullId(messages);
      if (cursor != null) {
        lastMessageId.value = cursor;
      } else {
        // If everything has null IDs, pagination can’t work
        allPagesLoaded.value = true;
      }
    });

    messages.refresh();
    update();
    isFirstLoadRunning.value = false;
  }

  Future<void> loadOlderMessages() async {
    if (isLoadMoreRunning.value) return;

    final cid = chatId?.value;
    if (cid == null) return; // or show error

    // If your API needs lastMessageId, don’t call with null
    final lastId = lastMessageId.value;
    if (lastId == null) {
      // Option A: don’t load older if we don’t know the cursor yet
      return;
      // Option B: call API without lastMessageId if supported
    }

    isLoadMoreRunning.value = true;

    try {
      final result = await repo.getOlderMessages(
        chatId: cid,
        lastMessageId: lastId,
      );

      result.fold((l) {
        // handle error if needed
      }, (r) {
        final data = r['data'];
        if (data is! List) return;

        final newMessages = data
            .map((e) => MessageModel.fromJson(e))
            .toList();

        if (newMessages.isEmpty) return;

        // ✅ pick the last NON-NULL messageId as cursor
        final lastNonNull = newMessages.lastWhere(
              (m) => m.messageId != null,
          orElse: () => newMessages.last,
        );

        if (lastNonNull.messageId != null) {
          lastMessageId.value = lastNonNull.messageId!;
        }

        messages.addAll(newMessages);
        messages.refresh();
      });
    } finally {
      isLoadMoreRunning.value = false;
      update();
    }
  }


  // Future loadOlderMessages() async {
  //   isLoadMoreRunning.value = true;
  //
  //   List<Message> newMessages = <Message>[];
  //
  //   var result = await repo.getOlderMessages(
  //     chatId: chatId!.value,
  //     lastMessageId: lastMessageId.value,
  //   );
  //
  //   result.fold((l) {}, (r) {
  //     var data = r['data'];
  //     for (int i = 0; i < (data as List).length; i++) {
  //       Message message = MessageModel.fromJson(data[i]);
  //       newMessages.add(message);
  //     }
  //
  //     if (newMessages.isNotEmpty) {
  //       lastMessageId.value = newMessages[newMessages.length - 1].messageId!;
  //
  //       messages.addAll(newMessages);
  //     } else {
  //       isLoadMoreRunning.value = false;
  //     }
  //   });
  //
  //   update();
  //   isLoadMoreRunning.value = false;
  // }

  //Get specific chat history
  Future<Map<String, dynamic>> getChatInfo({ClientUser? client}) async {
    final meetingsController = MeetingsController.instance;

    // print(client?.toJson());
    if (client != null) rxClient.value = client;

    loadingChatRoom.value = true;
    Either either = await repo.getChatInfo(
        consultantId: userDataStore.user['id'],
        clientId: meetingsController.currentMeeting.value!.client.id!,
        meetingId: meetingsController.currentMeeting.value!.id);

    var chatInfo = <String, dynamic>{};

    either.fold((l) {
      loadingChatRoom.value = false;

      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message.toString(),
          backgroundColor: ColorPalette.red);
    }, (r) {
      chatInfo = r['data'];
      // chatInfo.addAll(r['data']);

      chatId ??= RxInt(0);
      chatId!.value = chatInfo['id'];
      chatChannel.value = chatInfo['channel'];
    });

    if (isSmallScreen(Get.context!)) {
      Get.toNamed(
        Routes.CHAT_SCREEN,
        arguments: <String, dynamic>{
          "chat_id": chatId?.value,
          "client": client,
          "channel": chatChannel.value
        },
      );
    }

    await Future.delayed(const Duration(seconds: 1));

    loadRecentMessages();

    loadingChatRoom.value = false;

    return chatInfo;
  }

  void setVoiceFile(File file) {
    audioFile = file;
    update();
  }

  void addMessage(Message message) {
    messages.add(message);
    messages.sort((a, b) {
      final at = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return at.compareTo(bt);
    });
    messages.refresh();

    // Optionally scroll to bottom if needed
  }

  bool hasPusherJs() {
    try {
      return js_util.getProperty(html.window, 'Pusher') != null;
    } catch (_) {
      return false;
    }
  }

  Future initializePusher({required String channel}) async {
    try {
      // On web, pusher-js MUST be present
      if (kIsWeb && !hasPusherJs()) {
        debugPrint("Pusher JS not loaded on web. Skipping init.");
        return;
      }

      // Optional: only keep myChannel if you actually use it later
      myChannel = PusherChannel(channelName: channel);

      await pusher.init(
        apiKey: AppConfig.pusherKey,
        cluster: 'eu',
        onConnectionStateChange: (currentState, previousState) {
          debugPrint(
            "onConnectionStateChange: current=$currentState prev=$previousState",
          );
        },
        onError: (String message, int? code, dynamic e) {
          debugPrint("Pusher onError: $message code=$code ex=$e");
        },
        onSubscriptionSucceeded: (channelName, data) {
          debugPrint("onSubscriptionSucceeded: $channelName data=$data");
        },
        onEvent: (PusherEvent event) async {
          debugPrint("Received event: ${event.eventName}, data: ${event.data}");

          // Skip internal Pusher events
          if (event.eventName.startsWith('pusher:')) return;

          final eventData = safeEventData(event.data);
          if (!eventData.containsKey('message')) return;

          final rawMessage = eventData['message'];
          if (rawMessage == null) return;

          late final Map<String, dynamic> messageJson;

          if (rawMessage is String) {
            final decoded = jsonDecode(rawMessage);
            if (decoded is Map<String, dynamic>) {
              messageJson = decoded;
            } else if (decoded is Map) {
              messageJson = decoded.map((k, v) => MapEntry(k.toString(), v));
            } else {
              throw Exception(
                "Unexpected type for message: ${decoded.runtimeType}",
              );
            }
          } else if (rawMessage is Map) {
            messageJson = rawMessage.map((k, v) => MapEntry(k.toString(), v));
          } else {
            throw Exception(
              "Unsupported message type: ${rawMessage.runtimeType}",
            );
          }

          debugPrint("messageJson.created_at = ${messageJson['created_at']}");

          final message = MessageModel.fromJson(messageJson);

          if (event.eventName == 'incoming-call') {
            if (!(message.senderType?.toLowerCase() == 'consultant')) {
              handleIncomingCall(message);
              // vibration stuff...
            }
            return;
          }

          recentMsgEvent.value = message;

          if (!(message.senderType?.toLowerCase() == 'consultant')) {
            await Future.delayed(const Duration(seconds: 1));
            addMessage(message); // ✅ now this will run
          }

          debugPrint(
            "Event '${event.eventName}' received with message ID: ${message.messageId}",
          );
        },
        onSubscriptionError: (String message, dynamic e) {
          CustomSnackBar.errorSnackBar(
            "onSubscriptionError: $message Exception: $e",
          );
        },
      );

      // ✅ only subscribe/enter room after init succeeds
      enterChatRoom(channel);

      // connect last
      await pusher.connect();
    } catch (e, st) {
      debugPrint("initializePusher ERROR: $e\n$st");
    }
  }

  void enterChatRoom(String channel) async {
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
      print("success: ${r['message']}");
    });
  }

  void handleIncomingCall(MessageModel message) {
    final dashboardController = DashboardController.instance;

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
