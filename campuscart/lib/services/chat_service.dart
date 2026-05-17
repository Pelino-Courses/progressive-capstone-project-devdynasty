// ============================================================
// Phase 9 - Real-time Chat
// File: chat_service.dart
// Purpose: Wrapper around Cloud Firestore for chat.
//          Mirrors ProductFirestoreService - all chat-related
//          Firestore calls live in this ONE file.
//
// Firestore layout:
//   chats/{chatId}                 <- one per conversation
//     - participants: [uidA, uidB]
//     - productId, productTitle
//     - lastMessage, lastMessageAt
//   chats/{chatId}/messages/{msgId}<- the actual messages
//
// The chatId is built from the two user IDs + the product, so
// the same buyer + seller + product always reuse one thread.
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final CollectionReference _chatsRef =
      FirebaseFirestore.instance.collection('chats');

  // ===== CHAT ID =====

  /// Build a stable, unique chat id for a buyer + seller +
  /// product. Sorting the two UIDs means the order they are
  /// passed in does not matter - the same pair always maps to
  /// the same chat.
  String buildChatId({
    required String userA,
    required String userB,
    required String productId,
  }) {
    final ids = [userA, userB]..sort();
    return '${ids[0]}_${ids[1]}_$productId';
  }

  // ===== START / OPEN A CHAT =====

  /// Make sure a chat document exists. Called when a buyer taps
  /// "Chat Seller". If it already exists, nothing changes.
  Future<void> createChatIfNeeded({
    required String chatId,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
    required String productId,
    required String productTitle,
  }) async {
    final doc = await _chatsRef.doc(chatId).get();
    if (doc.exists) return;

    await _chatsRef.doc(chatId).set({
      'chatId': chatId,
      'participants': [buyerId, sellerId],
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productId': productId,
      'productTitle': productTitle,
      'lastMessage': '',
      'lastMessageAt': DateTime.now().toIso8601String(),
    });
  }

  // ===== SEND A MESSAGE =====

  Future<void> sendMessage({
    required String chatId,
    required ChatMessage message,
  }) async {
    // 1. Add the message to the sub-collection.
    await _chatsRef
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    // 2. Update the parent chat's preview info so the inbox
    //    can show the latest message without reading them all.
    await _chatsRef.doc(chatId).update({
      'lastMessage': message.text,
      'lastMessageAt': message.sentAt.toIso8601String(),
    });
  }

  // ===== READ MESSAGES (real-time) =====

  /// Live stream of all messages in one conversation, oldest
  /// first. The chat screen listens to this and rebuilds
  /// instantly whenever a new message arrives.
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return _chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ChatMessage.fromMap(doc.data()))
            .toList());
  }

  // ===== READ CHAT LIST (real-time) =====

  /// Live stream of every conversation the given user is part
  /// of, newest activity first. Powers the Messages inbox.
  Stream<List<Map<String, dynamic>>> streamUserChats(String userId) {
    return _chatsRef
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      final chats = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      // Sort newest-activity first (done in app code so we
      // don't need a Firestore composite index).
      chats.sort((a, b) {
        final aTime = DateTime.tryParse(
                a['lastMessageAt'] as String? ?? '') ??
            DateTime(2000);
        final bTime = DateTime.tryParse(
                b['lastMessageAt'] as String? ?? '') ??
            DateTime(2000);
        return bTime.compareTo(aTime);
      });
      return chats;
    });
  }
}
