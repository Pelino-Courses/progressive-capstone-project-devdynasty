// ============================================================
// Phase 9 - Real-time Chat
// File: chat_message.dart
// Purpose: Data model for a single chat message.
//
// Messages live in Firestore at:
//   chats/{chatId}/messages/{messageId}
//
// This is a plain model (no Hive) because chat is cloud-only -
// it streams live from Firestore the same way products do.
// ============================================================

class ChatMessage {
  final String id;
  final String senderId;   // Firebase UID of who sent it
  final String senderName; // display name, so we don't re-fetch
  final String text;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
  });

  // Convert to a Firestore-friendly map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
    };
  }

  // Build a ChatMessage from a Firestore map.
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? 'Unknown',
      text: map['text'] as String? ?? '',
      sentAt: DateTime.tryParse(map['sentAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
