import 'package:dartz/dartz.dart';
import 'package:tl_consultant/app/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/journal/domain/entities/note.dart';

abstract class JournalRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, dynamic>> getJournal(
      {required int page, required int limit});
}
