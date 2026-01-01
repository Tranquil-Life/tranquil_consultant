import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class ChatRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, T>> sendChat(
      {required String eventName,
      required String channel,
      required int? chatId,
      required String? message,
      required String messageType,
      String? caption,
      int? parentId});

  Future<Either<ApiError, T>> getRecentMessages({
    required int chatId,
  });

  Future<Either<ApiError, T>> getOlderMessages({
    required int chatId,
    required int lastMessageId,
  });

  Future<Either<ApiError, T>> getChatInfo(
      {required int consultantId,
      required int clientId,
      required int meetingId});

  Future<Either<ApiError, T>> react();

  Future<Either<ApiError, T>> deleteMessage();

  Future<Either<ApiError, T>> onEnding();

  Future<Either<ApiError, T>> getAgoraToken(String channelId, int meetingId);

  Future<Either<ApiError, T>> rateClient();

  Future<Either<ApiError, T>> triggerPusherEvent(
      String channel, String eventName, Map<String, dynamic> data);

  Future<Either<ApiError, T>> generateDailyToken(
      {required String room, required int timeLeft, required String userType});

  Future<Either<ApiError, T>> createDailyRoom(
      {required String channel, required int timeLeft, required int chatId});

  void saveCompletedVideoCall(
      {required int meetingId, required int durationSeconds});
}
