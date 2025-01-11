import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/chat/domain/repos/chat_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class ChatRepoImpl extends ChatRepo {
  @override
  Future<Either<ApiError, dynamic>> deleteChat() {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> endSession() {
    // TODO: implement endSession
    throw UnimplementedError();
  }

  @override
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
      {required int? chatId,
      required String message,
      required String messageType,
      String? caption,
      int? parentId}) async {
    final body = {
      "chat_id": chatId,
      "message": message,
      "message_type": messageType,
      "caption": caption,
      "parent_id": parentId,
    };

    return await catchSocketException(
            () => postReq(ChatEndPoints.sendChat, body: body))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getChatInfo(
      {required int consultantId, required int clientId}) async {
    var data = {
      "consultant_id": consultantId,
      "client_id": clientId,
    };
    print(data);

    return await catchSocketException(
            () => postReq(ChatEndPoints.getChatInfo, body: data))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getAgoraToken(String channelId) async {
    var input = {
      "display_name": userDataStore.user['f_name'],
      "channel_name": channelId,
    };

    return await catchSocketException(
            () => postReq(ChatEndPoints.generateToken, body: input))
        .then((value) => handleResponse(value));
  }
}
