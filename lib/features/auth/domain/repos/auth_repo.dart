import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class AuthRepo<T, F extends QueryParams> extends ApiService {
  AuthRepo();

  Future<Either<ApiError, dynamic>> register(F params);
  Future<Either<ApiError, T>> signIn(String email, String password);
  Future<Either<ApiError, dynamic>> resetPassword(String email);
  Future<Either<ApiError, dynamic>> signOut();
  Future<Either<ApiError, dynamic>> generateFcmToken();
  Future<Either<ApiError, dynamic>> sendTokenToEndpoint(String newToken);
  Future<Either<ApiError, dynamic>> isAuthenticated();
  Future<Either<ApiError, dynamic>> requestVerificationToken({required String email});
  Future<Either<ApiError, dynamic>> verifyAccount(String token);
}
