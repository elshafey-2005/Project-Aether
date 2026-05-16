import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String user;
  final String message;
  final DateTime timestamp;
  final bool isMe;
  final bool isSystem;

  ChatMessage({
    required this.id,
    required this.user,
    required this.message,
    required this.timestamp,
    this.isMe = false,
    this.isSystem = false,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc, String currentUserId) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      user: data['user'] ?? 'Unknown',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isMe: data['userId'] == currentUserId,
      isSystem: data['isSystem'] ?? false,
    );
  }
}
