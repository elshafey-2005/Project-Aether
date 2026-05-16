import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'global_chat';

  /// Streams latest messages with a limit to optimize performance.
  Stream<List<ChatMessage>> getMessagesStream(String currentUserId) {
    return _firestore
        .collection(_collectionPath)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc, currentUserId))
          .toList()
          .reversed
          .toList();
    });
  }

  /// Sends a message to the global chat.
  Future<void> sendMessage(String userId, String username, String text) async {
    if (text.trim().isEmpty) return;

    await _firestore.collection(_collectionPath).add({
      'userId': userId,
      'user': username,
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'isSystem': false,
    });
  }
}
