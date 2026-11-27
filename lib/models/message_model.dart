import 'user_model.dart';
import 'specialist_model.dart';

class ConversationModel {
  final String id;
  final UserModel? client;
  final SpecialistModel? specialist;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  const ConversationModel({
    required this.id,
    this.client,
    this.specialist,
    required this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? '',
      client: json['client'] is Map<String, dynamic>
          ? UserModel.fromJson(json['client'])
          : null,
      specialist: json['specialist'] is Map<String, dynamic>
          ? SpecialistModel.fromJson(json['specialist'])
          : null,
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String conversationId;
  final UserModel? sender;
  final String content;
  final bool isRead;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.id,
    required this.conversationId,
    this.sender,
    required this.content,
    this.isRead = true,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      sender: json['sender'] is Map<String, dynamic>
          ? UserModel.fromJson(json['sender'])
          : null,
      content: json['content']?.toString() ?? '',
      isRead: json['isRead'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
