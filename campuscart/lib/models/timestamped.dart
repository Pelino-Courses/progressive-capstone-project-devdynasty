// ============================================================
// PART B - OOP & Data Models
// File: timestamped.dart
// Purpose: Timestamped MIXIN - adds date tracking to any class.
// ============================================================

mixin Timestamped {
  DateTime createdAt = DateTime.now();
  DateTime? updatedAt;

  // Mark as updated NOW
  void markUpdated() {
    updatedAt = DateTime.now();
  }

  // How many days ago was this created?
  int get daysSinceCreated {
    return DateTime.now().difference(createdAt).inDays;
  }

  // Human-friendly posted time
  String get postedTimeAgo {
    final days = daysSinceCreated;
    if (days == 0) return 'Posted today';
    if (days == 1) return 'Posted yesterday';
    if (days < 7) return 'Posted $days days ago';
    if (days < 30) return 'Posted ${(days / 7).floor()} weeks ago';
    return 'Posted ${(days / 30).floor()} months ago';
  }
}