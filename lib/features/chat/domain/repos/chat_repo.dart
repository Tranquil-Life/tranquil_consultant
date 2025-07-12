import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class ChatRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, T>> sendChat(
      { required int? chatId,
        required String? message,
        required String messageType,
        String? caption,
        int? parentId,
        int? clientId});
  Future<Either<ApiError, T>> getRecentMessages({
    required int chatId,
  });
  Future<Either<ApiError, T>> getOlderMessages({
    required int chatId,
    required int lastMessageId,
  });
  Future<Either<ApiError, T>> getChatInfo(
      {required int consultantId, required int clientId});
  Future<Either<ApiError, T>> react();
  Future<Either<ApiError, T>> deleteChat();
  Future<Either<ApiError, T>> onEnding();
  Future<Either<ApiError, T>> getAgoraToken(String channelId);
  Future<Either<ApiError, T>> rateClient();
}
