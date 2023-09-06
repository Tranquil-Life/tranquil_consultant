class Participant{
  final int userId;
  final String displayName;
  final String avatar;
  final String userType;

  Participant({
    required this.userId,
    required this.displayName,
    required this.avatar,
    required this.userType,
  });

}

class ParticipantModel extends Participant{
  ParticipantModel({
    required super.userId,
    required super.displayName,
    required super.avatar,
    required super.userType});

  factory ParticipantModel.fromJson(Map<String, dynamic> json) => _$ParticipantModelFromJson(json);

}

_$ParticipantModelFromJson(Map<String, dynamic> json)=>
    Participant(
        userId: json['id'] as int,
        avatar: json['avatar_url'].toString() ?? '',
        displayName: json['display_name'].toString() ?? '',
        userType: json['user_type'].toString() ?? ''
    );