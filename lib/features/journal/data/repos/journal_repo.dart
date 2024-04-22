import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:tl_consultant/core/constants/end_points.dart';
import 'package:tl_consultant/core/errors/api_error.dart';
import 'package:tl_consultant/features/journal/domain/entities/shared_note/note.dart';
import 'package:tl_consultant/features/journal/domain/repos/journal_repo.dart';

class JournalRepoImpl extends JournalRepo {
  @override
  Future<Either<ApiError, dynamic>> getPersonalNotes(
      {required int page, required int limit}) async {
    return await catchSocketException(() => getReq(
          JournalEndPoints.personalNotes(page: page, limit: limit),
        )).then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> getSharedNotes(
      {required int page, required int limit}) async {
    return await catchSocketException(() => getReq(
          JournalEndPoints.sharedNotes(page: page, limit: limit),
        )).then((value) => handleResponse(value));
  }

  Future<Either<ApiError, dynamic>> deleteNote(List<Note> notes) async {
    return await catchSocketException(() =>
            deleteReq(JournalEndPoints.deleteNote, body: {'id': notes[0].id}))
        .then((value) => handleResponse(value));
  }

  Future<Either<ApiError, dynamic>> fetchJournal(
      {required int page, required int limit}) async {
    return await catchSocketException(() => getReq(JournalEndPoints.fetchNote))
        .then((value) => handleResponse(value));
  }

  @override
  Future<Either<ApiError, dynamic>> addNote({required Note note}) async {
    return await catchSocketException(() => postReq(JournalEndPoints.addNote))
        .then((value) => handleResponse(value));
  }
}
