import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import 'chat_provider.dart';

class ChatSection extends ConsumerStatefulWidget {
  const ChatSection({super.key});

  @override
  ConsumerState<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends ConsumerState<ChatSection> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatServiceProvider).sendMessage('current_user_123', 'You', text);
      _controller.clear();

      // Auto-scroll after a short delay to allow the stream to update
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider);

    return Column(
      children: [
        _buildChannelHeader(),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.02)),
            ),
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _ChatBubble(
                    user: msg.user,
                    message: msg.message,
                    isMe: msg.isMe,
                    isSystem: msg.isSystem,
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.cyanNeon)),
              error: (err, stack) => Center(child: Text('Error loading comms: $err', style: const TextStyle(color: Colors.red, fontSize: 10))),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildChannelHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('COMMS CHANNEL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white60)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
          child: const Row(
            children: [
              CircleAvatar(radius: 2, backgroundColor: Colors.greenAccent),
              SizedBox(width: 4),
              Text('LIVE // 2.4k', style: TextStyle(fontSize: 8, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'UPLOAD MESSAGE...',
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 1),
              filled: true,
              fillColor: AppTheme.surfaceDark,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
            ),
            onSubmitted: (_) => _handleSend(),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filled(
          onPressed: _handleSend,
          icon: const Icon(Icons.send_rounded, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.cyanNeon,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String user;
  final String message;
  final bool isMe;
  final bool isSystem;

  const _ChatBubble({
    required this.user,
    required this.message,
    required this.isMe,
    required this.isSystem,
  });

  @override
  Widget build(BuildContext context) {
    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Text(
            message.toUpperCase(),
            style: const TextStyle(color: AppTheme.pinkNeon, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMe ? 'YOU' : user,
                style: TextStyle(
                  color: isMe ? AppTheme.cyanNeon : AppTheme.purpleNeon,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('NOW', style: TextStyle(color: Colors.white10, fontSize: 9)),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.cyanNeon.withOpacity(0.08) : Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isMe ? 12 : 2),
                bottomRight: Radius.circular(isMe ? 2 : 12),
              ),
              border: Border.all(
                color: isMe ? AppTheme.cyanNeon.withOpacity(0.2) : Colors.white.withOpacity(0.05),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(color: isMe ? Colors.white : Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
