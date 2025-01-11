import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class Qualification {
  final int? id;
  final int? consultantId;
  final String certification;
  final String institution;
  final String yearAwarded;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Qualification({
    required this.id,
    this.consultantId,
    this.certification = '',
    this.institution = '',
    this.yearAwarded = '',
     this.createdAt,
     this.updatedAt,
  });

  // Factory constructor for creating a Qualification instance from JSON
  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      id: json['id'] as int? ?? DateTime.now().millisecondsSinceEpoch, // Use current timestamp as unique id
      consultantId: json['consultant_id'] as int? ?? UserModel.fromJson(userDataStore.user).id,
      certification: json['certification'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      yearAwarded: json['year_awarded'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  // Method for converting a Qualification instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultant_id': consultantId,
      'certification': certification,
      'institution': institution,
      'year_awarded': yearAwarded,
      // 'created_at': createdAt.toIso8601String(),
      // 'updated_at': updatedAt.toIso8601String(),
    };
  }
}
