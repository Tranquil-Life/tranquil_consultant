class RatingModel {
  final int meetingId;
  final int participantId;
  final int ratingByConsultant;
  final String? commentByConsultant;
  final String? userRole;
  final int? overallMeetingRatingByConsultant;

  RatingModel({
    required this.meetingId,
    required this.participantId,
    required this.ratingByConsultant,
    this.commentByConsultant,
    this.userRole,
    this.overallMeetingRatingByConsultant,
  });

  /// Convert JSON -> Model
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      meetingId: json['meeting_id'] is String
          ? int.parse(json['meeting_id'])
          : json['meeting_id'] ?? 0,
      participantId: json['participant_id'] is String
          ? int.parse(json['participant_id'])
          : json['participant_id'] ?? 0,
      ratingByConsultant: json['rating_by_consultant'] is String
          ? int.parse(json['rating_by_consultant'])
          : json['rating_by_consultant'] ?? 0,
      commentByConsultant: json['comment_by_consultant'] ?? '',
      overallMeetingRatingByConsultant:
      json['overall_meeting_rating_by_consultant'] is String
          ? int.parse(json['overall_meeting_rating_by_consultant'])
          : json['overall_meeting_rating_by_consultant'] ?? 0,
    );
  }

  /// Convert Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      "meeting_id": meetingId,
      "participant_id": participantId,
      "rating_by_consultant": ratingByConsultant,
      "comment_by_consultant": commentByConsultant,
      "user_role": "consultant",
      "overall_meeting_rating_by_consultant":
      ratingByConsultant,
    };
  }
}
