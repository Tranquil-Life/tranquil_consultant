import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/chat/domain/repos/chat_repo.dart';


class ChatRepoImpl extends ChatRepo{
  @override
  Future<Either<ApiError, dynamic>> uploadFile() {
    // TODO: implement attach
    throw UnimplementedError();
  }

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
  Future<Either<ApiError, dynamic>> viewParticipants() {
    // TODO: implement viewParticipants
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> uploadChat({
    required int meetingId,
    required String message,
    required String messageType,
    String caption = '',
    int parentId = 0}) async
  {

    final data = {
      "meeting_id": meetingId,
      "message": message,
      "message_type": messageType,
      "caption": caption,
      "parent_id": parentId
    };

    try{
      httpClient.baseUrl = baseUrl;

      Response response = await postReq(
          ChatEndPoints.uploadChat,
          body: data
      );

      print(response.body);
      if(response.body['error'] == false){
        var data = response.body['chat'];

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
  Future<Either<ApiError, dynamic>> getChats({required int meetingId})
  async{

    try{
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(
          ChatEndPoints.getChats(meetingId: meetingId));

      if(response.body['error'] == false){
        var data = response.body['chats'];

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
  Future<Either<ApiError, dynamic>> rateClient() {
    // TODO: implement rateClient
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, dynamic>> getClientName({required int clientId}) async{
    try{
      httpClient.baseUrl = baseUrl;

      Response response = await getReq(
          ChatEndPoints.clientName(clientId: clientId));

      if(response.body['error'] == false){
        var data = response.body['name'];

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
}