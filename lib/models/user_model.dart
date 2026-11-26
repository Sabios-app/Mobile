class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // CLIENT, CONSELHEIRO, etc.
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatarUrl,
    this.createdAt,
  });

  bool get isCounselor =>
      role.toUpperCase() == 'CONSELHEIRO' ||
      role.toUpperCase() == 'COUNSELOR' ||
      role.toUpperCase() == 'SPECIALIST';
  bool get isClient => role.toUpperCase() == 'CLIENT';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'CLIENT',
      phone: json['phone']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    if (phone != null) 'phone': phone,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
  };
}
