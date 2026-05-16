import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_service.dart';
import '../domain/chat_message.dart';

final chatServiceProvider = Provider((ref) => ChatService());

final chatMessagesProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref) {
  final service = ref.watch(chatServiceProvider);
  // Using a mock current user ID for demonstration
  return service.getMessagesStream('current_user_123');
});
