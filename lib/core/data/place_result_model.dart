class PlaceResultModel {
  final String name;
  final String placeId;
  final String formattedAddress;

  PlaceResultModel({required this.name, required this.placeId, required this.formattedAddress});

  factory PlaceResultModel.fromJson(Map<String, dynamic> json) {
    return PlaceResultModel(
      name: json['name'],
      placeId: json['place_id'],
      formattedAddress: json['formatted_address'],
    );
  }
}