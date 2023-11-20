import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class ChatRepo<T, F extends QueryParams> extends ApiService{
  Future<Either<ApiError, T>> uploadChat({
    required int meetingId,
    required String message,
    required String messageType,
    String caption='',
    int parentId=0
  });

  Future<Either<ApiError, T>> getChats({
    required int meetingId
  });

  Future<Either<ApiError, T>> react();
  Future<Either<ApiError, T>> deleteChat();
  Future<Either<ApiError, T>> uploadFile();
  Future<Either<ApiError, T>> viewParticipants();
  Future<Either<ApiError, T>> onEnding();
  Future<Either<ApiError, T>> rateClient();
  Future<Either<ApiError, T>> getClientName({
    required int clientId
  });
}