class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? mentoringId;
  final bool read;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.mentoringId,
    this.read = false,
    this.createdAt,
  });

  NotificationModel copyWith({bool? read}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      message: message,
      mentoringId: mentoringId,
      read: read ?? this.read,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'MENTORING_REQUESTED',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      mentoringId: json['mentoringId']?.toString(),
      read: json['read'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
