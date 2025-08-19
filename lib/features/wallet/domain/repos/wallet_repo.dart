import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/wallet/domain/entities/create_stripe_account.dart';
import 'package:tl_consultant/features/wallet/domain/entities/earnings.dart';

abstract class WalletRepo<T, F extends QueryParams> extends ApiService {
  WalletRepo();

  Future<Either<ApiError, dynamic>> getWallet();

  Future<Either<ApiError, dynamic>> getTransactions(
      {required int page, required int limit});

  Future<Either<ApiError, dynamic>> getCountries();

  Future<Either<ApiError, dynamic>> getStates({required String country});

  Future<Either<ApiError, dynamic>> getCities(
      {required String country, required String state});

  Future<Either<ApiError, dynamic>> getBankBranches(
      {required String bankName, required String state});

  Future<Either<ApiError, dynamic>> getFromNextPage(
      {required String nextPageToken});

  Future<Either<ApiError, dynamic>> createStripeAccount({
    required CreateStripeAccount params});
  Future<Either<ApiError, dynamic>> getStripeAccountInfo();
  Future<Either<ApiError, dynamic>> getBalance();
  Future<Either<ApiError, dynamic>> getTotalPendingClearance();
  Future<Either<ApiError, dynamic>> getLifeTimeTotalReceived();
  Future<Either<ApiError, dynamic>> transferToConnectedAcc({required int amount});
  Future<Either<ApiError, dynamic>> withdrawToBankAcc(Map<String, dynamic> req);

}
