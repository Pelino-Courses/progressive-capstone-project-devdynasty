// ============================================================
// Phase 9 - Real-time Chat
// File: messages_screen.dart
// Purpose: The chat inbox - a live list of every conversation
//          the logged-in user is part of. Tapping one opens
//          the full thread (ConversationScreen).
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/chat_service.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'conversation_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatService = ChatService();
    final userProvider = context.watch<UserProvider>();
    final myId = userProvider.userId;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Messages')),
      body: myId.isEmpty
          ? const Center(child: Text('Please sign in to see messages'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatService.streamUserChats(myId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data ?? [];

                if (chats.isEmpty) {
                  return _emptyState();
                }

                return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (context, index) {
                    return _chatTile(context, chats[index], myId);
                  },
                );
              },
            ),
    );
  }

  Widget _chatTile(
      BuildContext context, Map<String, dynamic> chat, String myId) {
    // Work out who the OTHER person is.
    final buyerId = chat['buyerId'] as String? ?? '';
    final otherName = (myId == buyerId)
        ? (chat['sellerName'] as String? ?? 'Seller')
        : (chat['buyerName'] as String? ?? 'Buyer');

    final lastMessage = chat['lastMessage'] as String? ?? '';
    final productTitle = chat['productTitle'] as String? ?? '';
    final lastAt =
        DateTime.tryParse(chat['lastMessageAt'] as String? ?? '');

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: Text(
          otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        otherName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productTitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            lastMessage.isEmpty ? 'No messages yet' : lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
      trailing: lastAt != null
          ? Text(
              _formatTime(lastAt),
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary),
            )
          : null,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/conversation',
          arguments: ConversationArgs(
            chatId: chat['chatId'] as String? ?? '',
            otherUserName: otherName,
            productTitle: productTitle,
            buyerId: chat['buyerId'] as String? ?? '',
            buyerName: chat['buyerName'] as String? ?? '',
            sellerId: chat['sellerId'] as String? ?? '',
            sellerName: chat['sellerName'] as String? ?? '',
            productId: chat['productId'] as String? ?? '',
          ),
        );
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Open a product and tap "Chat Seller" to start.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final sameDay =
        t.year == now.year && t.month == now.month && t.day == now.day;
    if (sameDay) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${t.day}/${t.month}';
  }
}
