import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/chat/domain/repos/chat_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/main.dart';

class ChatRepoImpl extends ChatRepo {
  @override
  Future<Either<ApiError, dynamic>> deleteMessage() {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  Future<Either<ApiError, dynamic>> endSession() {
    // TODO: implement endSession
    throw UnimplementedError();
  }

  Future<Either<ApiError, dynamic>> invite() {
    // TODO: implement invite
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> onEnding() {
    // TODO: implement onEnding
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> react() {
    // TODO: implement react
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> rateClient() {
    // TODO: implement rateClient
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> getRecentMessages(
      {required int chatId}) async {
    return await catchSocketException(
            () => getReq(ChatEndPoints.getRecentMessages(chatId: chatId)))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getOlderMessages(
      {required int chatId, required int lastMessageId}) async {
    return await catchSocketException(() => getReq(
            ChatEndPoints.getOlderMessages(
                chatId: chatId, lastMessageId: lastMessageId)))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> sendChat(
      {required String eventName,
      required String channel,
      required int? chatId,
      required String? message,
      required String messageType,
      String? caption,
      int? parentId}) async {
    final body = {
      "chat_id": chatId,
      "message": message,
      "message_type": messageType,
      "parent_id": parentId,
      "caption": caption,
      "ai_chat": false,
      'event_name': eventName,
      'channel': channel
    };

    return await catchSocketException(
            () => postReq(ChatEndPoints.sendChat, body: body))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getChatInfo(
      {required int consultantId,
      required int clientId,
      required int meetingId}) async {
    var data = {
      "consultant_id": consultantId,
      "client_id": clientId,
      "meeting_id": meetingId
    };

    return await catchSocketException(
            () => postReq(ChatEndPoints.getChatInfo, body: data))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getAgoraToken(
      String channelId, int meetingId) async {
    var input = {
      "channel_name": channelId,
      "meeting_id": meetingId,
      "user_id": userDataStore.user['id']
    };

    return await catchSocketException(
            () => postReq(ChatEndPoints.generateToken, body: input))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> triggerPusherEvent(
      String channel, String eventName, Map<String, dynamic> data) async {
    var input = {"channel": channel, "event_name": eventName, "data": data};

    return await catchSocketException(
      () => postReq(ChatEndPoints.triggerPusherEvent, body: input),
    ).then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> createDailyRoom({
    required String channel,
    required int timeLeft,
    required int chatId,
  }) async {
    final input = {
      "channel_name": channel,
      "time_left": timeLeft,
      "chat_id": chatId,
    };

    return await catchSocketException(
      () => postReq(ChatEndPoints.createDailyRoom, body: input),
    ).then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> generateDailyToken({
    required String room,
    required int timeLeft,
    required String userType,
  }) async {
    final input = {
      "room": room,
      "time_left": timeLeft,
      "user_type": userType,
    };

    final result = await catchSocketException(
          () => postReq(ChatEndPoints.generateDailyToken, body: input),
    );

    return result; // already an Either
  }

  @override
  void saveCompletedVideoCall({required int meetingId, required int durationSeconds}) {
    storage.write('last_complete_video_call', {
      'duration': durationSeconds,
      'meeting_id': meetingId,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }
}
