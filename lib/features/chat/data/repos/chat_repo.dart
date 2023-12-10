import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/chat/domain/repos/chat_repo.dart';


class ChatRepoImpl extends ChatRepo{
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
  Future<Either<ApiError, dynamic>> getRecentMessages({required int chatId})
  async{
    try{
      httpClient.baseUrl = baseUrl;

      // debugPrint("recent messages:CHAT_ID: ${chatId.toString()}");

      Response response = await getReq(
          ChatEndPoints.getRecentMessages(chatId: chatId));

      if(response.body['error'] == false){
        var data = response.body['data'];

        return Right(data);
      }
      else{
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }

    }on SocketException catch (e) {
      return Left(ApiError(
          message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getOlderMessages({required int chatId, required int lastMessageId})
  async{
    try{
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(
          ChatEndPoints.getOlderMessages(chatId: chatId, lastMessageId: lastMessageId));


      if(response.body['error'] == false){
        var data = response.body['data'];

        return Right(data);
      }
      else{
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }

    }on SocketException catch (e) {
      return Left(ApiError(
          message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> sendChat({
    required int? chatId,
    required String message,
    required String messageType,
    String? caption,
    int? parentId})
  async {
    final data = {
      "chat_id": chatId,
      "message": message,
      "message_type": messageType,
      "caption": caption,
      "parent_id": parentId,
    };

    try{
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
          ChatEndPoints.sendChat,
          body: data
      );

      await Future.delayed(const Duration(seconds: 1));

      if(response.body['error'] == false){
        var data = response.body['data'];

        return Right(data);
      }
      else{
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }

    }on SocketException catch (e) {
      return Left(ApiError(
          message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<ApiError, dynamic>> getChatInfo({
    required int consultantId,
    required int clientId})
  async {
    try{
      httpClient.baseUrl = baseUrl;

      var data = {
        "consultant_id": consultantId,
        "client_id": clientId,
      };

      Response response = await postReq(
          ChatEndPoints.getChatInfo,
          body: data);

      if(response.body['message'] == "Chat already exist"){
        var res = response.body['data'];

        return Right(res);
      }
      else{
        return Left(
          ApiError(message: response.body['message'].toString()),
        );
      }

    }on SocketException catch (e) {
      return Left(ApiError(
          message: e.toString()));
    } catch (e, stack) {
      debugPrintStack(stackTrace: stack);
      return Left(ApiError(
        message: e.toString(),
      ));
    }
  }

}