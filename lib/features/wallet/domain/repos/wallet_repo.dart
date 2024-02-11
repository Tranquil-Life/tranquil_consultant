import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

abstract class WalletRepo extends ApiService{
  WalletRepo();

  Future<Either<ApiError, dynamic>> getWallet();

  Future<Either<ApiError, dynamic>> getTransactions({
    required int page,
    required int limit
  });
}