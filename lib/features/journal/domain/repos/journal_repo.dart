import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';
import 'package:tl_consultant/features/consultation/domain/entities/client.dart';
import 'package:tl_consultant/features/journal/domain/entities/personal_note.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/note.dart';

abstract class JournalRepo<T, F extends QueryParams> extends ApiService {
  Future<Either<ApiError, dynamic>> getPersonalNotes(
      {required int page, required int limit});

  Future<Either<ApiError, dynamic>> getSharedNotes(
      {required int page, required int limit});

  Future<Either<ApiError, dynamic>> addNote({required PersonalNote note});
}
