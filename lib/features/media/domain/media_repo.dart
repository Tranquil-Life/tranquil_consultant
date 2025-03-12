import 'package:tl_consultant/core/domain/query_params.dart';
import 'package:tl_consultant/core/utils/services/API/api_service.dart';

abstract class MediaRepo<T, F extends QueryParams> extends ApiService {
  // Future<Either<ApiError, T>> uploadFileWithHttp(File file, String uploadType,
  //     [String? previousImgUrl]);
}
