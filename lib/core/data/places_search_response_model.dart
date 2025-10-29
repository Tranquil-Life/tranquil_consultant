import 'package:tl_consultant/core/data/place_result_model.dart';

class PlacesSearchResponseModel {
  final List<PlaceResultModel> results;
  final String? nextPageToken;

  PlacesSearchResponseModel({required this.results, this.nextPageToken});

  factory PlacesSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return PlacesSearchResponseModel(
      results: (json['results'] as List)
          .map((e) => PlaceResultModel.fromJson(e))
          .toList(),
      nextPageToken: json['next_page_token'],
    );
  }
}
