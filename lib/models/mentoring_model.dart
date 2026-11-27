import 'user_model.dart';
import 'specialist_model.dart';

class MentoringModel {
  final String id;
  final UserModel? client;
  final SpecialistModel? specialist;
  final String title;
  final String? description;
  final String? doubts;
  final String status; // REQUESTED, CONFIRMED, COMPLETED, CANCELED
  final DateTime? scheduledAt;
  final String? meetingLink;
  final DateTime? createdAt;

  const MentoringModel({
    required this.id,
    this.client,
    this.specialist,
    required this.title,
    this.description,
    this.doubts,
    this.status = 'CONFIRMED',
    this.scheduledAt,
    this.meetingLink,
    this.createdAt,
  });

  bool get isConfirmed => status.toUpperCase() == 'CONFIRMED';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';

  factory MentoringModel.fromJson(Map<String, dynamic> json) {
    return MentoringModel(
      id: json['id']?.toString() ?? '',
      client: json['client'] is Map<String, dynamic>
          ? UserModel.fromJson(json['client'])
          : null,
      specialist: json['specialist'] is Map<String, dynamic>
          ? SpecialistModel.fromJson(json['specialist'])
          : null,
      title: json['title']?.toString() ?? 'Sessão de Mentoria',
      description: json['description']?.toString(),
      doubts: json['doubts']?.toString(),
      status: json['status']?.toString() ?? 'CONFIRMED',
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'].toString())
          : null,
      meetingLink: json['meetingLink']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
