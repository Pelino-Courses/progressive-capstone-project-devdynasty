// ============================================================
// Phase 9 - Real-time Chat
// File: conversation_screen.dart
// Purpose: A single chat thread between two users about a
//          product. Messages stream live from Firestore.
//
// It is opened with a ConversationArgs object (passed as the
// route's `arguments`) carrying everyone's IDs and names.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

/// Everything ConversationScreen needs, passed via route args.
class ConversationArgs {
  final String chatId;
  final String otherUserName; // who you are talking to
  final String productTitle;

  // Used to create the chat document the first time.
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String productId;

  const ConversationArgs({
    required this.chatId,
    required this.otherUserName,
    required this.productTitle,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.productId,
  });
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSending = false;
  bool _chatEnsured = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Make sure the chat document exists (first message only).
  Future<void> _ensureChat(ConversationArgs args) async {
    if (_chatEnsured) return;
    _chatEnsured = true;
    await _chatService.createChatIfNeeded(
      chatId: args.chatId,
      buyerId: args.buyerId,
      buyerName: args.buyerName,
      sellerId: args.sellerId,
      sellerName: args.sellerName,
      productId: args.productId,
      productTitle: args.productTitle,
    );
  }

  Future<void> _sendMessage(ConversationArgs args) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userProvider = context.read<UserProvider>();

    setState(() => _isSending = true);

    try {
      await _ensureChat(args);

      final message = ChatMessage(
        id: 'M${DateTime.now().millisecondsSinceEpoch}',
        senderId: userProvider.userId,
        senderName: userProvider.userName,
        text: text,
        sentAt: DateTime.now(),
      );

      await _chatService.sendMessage(
        chatId: args.chatId,
        message: message,
      );

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    // Wait a frame so the new message is laid out first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // The screen needs its arguments to do anything.
    final args =
        ModalRoute.of(context)!.settings.arguments as ConversationArgs?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('No conversation selected')),
      );
    }

    final myId = context.watch<UserProvider>().userId;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(args.otherUserName,
                style: const TextStyle(fontSize: 16)),
            Text(
              args.productTitle,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ===== MESSAGE LIST (real-time) =====
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.streamMessages(args.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return _emptyState(args.otherUserName);
                }

                // New data arrived - scroll down to show it.
                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMine = msg.senderId == myId;
                    return _MessageBubble(message: msg, isMine: isMine);
                  },
                );
              },
            ),
          ),

          // ===== INPUT BAR =====
          _buildInputBar(args),
        ],
      ),
    );
  }

  Widget _emptyState(String otherName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Say hi to $otherName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ask about the product, price, or pickup.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(ConversationArgs args) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(args),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryColor,
              child: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(args),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== A SINGLE CHAT BUBBLE =====
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const _MessageBubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: isMine
              ? null
              : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 15,
                color: isMine ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _formatTime(message.sentAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine
                    ? Colors.white.withOpacity(0.8)
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
