import 'user_model.dart';

class SpecialistModel {
  final String id;
  final UserModel user;
  final String title;
  final String specialty;
  final String bio;
  final double rating;
  final double hourlyRate;
  final bool isAvailable;
  final DateTime? createdAt;

  const SpecialistModel({
    required this.id,
    required this.user,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.rating,
    required this.hourlyRate,
    this.isAvailable = true,
    this.createdAt,
  });

  factory SpecialistModel.fromJson(Map<String, dynamic> json) {
    return SpecialistModel(
      id: json['id']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? UserModel.fromJson(json['user'])
          : UserModel(
              id: '',
              name: json['name']?.toString() ?? '',
              email: '',
              role: 'CONSELHEIRO',
              avatarUrl: json['avatarUrl']?.toString(),
            ),
      title: json['title']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] == true || json['available'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
