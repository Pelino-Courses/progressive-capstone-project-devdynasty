# Phase 9 — Real-time Chat Between Buyers & Sellers

> **Team:** DevDynasty
> **Goal:** Let a buyer message a seller about a product, with
> messages appearing **instantly** on both sides — real-time
> chat powered by Cloud Firestore.

---

## What Phase 9 adds

The product details screen already had a **"Chat Seller"**
button — but it only showed a fake snackbar. Phase 9 makes it
real:

- Tap **Chat Seller** → opens a live conversation thread.
- Type a message → it appears instantly for both people.
- A **Messages** inbox (chat icon in the home app bar) lists
  all your conversations, newest first.

It works the same way as Phase 7's product sync: Firestore
streams the data live, so no refresh button is ever needed.

---

## How it works (the design)

Firestore layout:

```
chats/{chatId}
  participants: [buyerUid, sellerUid]
  buyerId, buyerName, sellerId, sellerName
  productId, productTitle
  lastMessage, lastMessageAt        <- for the inbox preview

chats/{chatId}/messages/{messageId}
  senderId, senderName, text, sentAt
```

The `chatId` is built from the two user IDs (sorted) plus the
product ID, so the same buyer + seller + product always reuse
**one** thread instead of creating duplicates.

---

## Files added / changed

| File | Change |
|------|--------|
| `lib/models/chat_message.dart` | **New** — message data model |
| `lib/services/chat_service.dart` | **New** — Firestore chat wrapper (mirrors `ProductFirestoreService`) |
| `lib/screens/conversation_screen.dart` | **New** — the chat thread (bubbles + input) |
| `lib/screens/messages_screen.dart` | **New** — the inbox of all conversations |
| `lib/screens/product_details_screen.dart` | Edited — "Chat Seller" button now opens a real chat |
| `lib/screens/home_screen.dart` | Edited — added a Messages icon to the app bar |
| `lib/screens/add_listing_screen.dart` | Edited — new listings now use the real logged-in user as the seller (so chats reach the right person) |
| `lib/main.dart` | Edited — registered `/messages` and `/conversation` routes |

---

## Setup — there's almost nothing to do

Chat uses **Cloud Firestore**, which you already enabled in
Phase 7. So there is **no new Firebase product to turn on**.

Just install and run:

```bash
cd campuscart
flutter pub get
flutter run
```

(No new packages were added either — `cloud_firestore` from
Phase 7 covers chat. `flutter pub get` is just good practice.)

---

## How to test Phase 9

Real chat needs **two accounts**. Easiest setup: run the app in
two places (e.g. Chrome + an emulator, or two browser windows),
or sign out and back in as a different user.

1. **Account A** posts a product (or use a seeded one — but
   seeded products have a fake seller, so a posted one is best
   for a true two-way test).
2. **Account B** opens that product → taps **Chat Seller** →
   types "Hi, is this still available?" → sends.
3. **Account A** taps the **Messages** icon (top of home) →
   sees the conversation → opens it → the message is there.
4. Account A replies. Watch it appear on **Account B's** screen
   **instantly**, with no refresh.
5. Open the Firebase console → **Firestore → chats** — you can
   see the chat document and its `messages` sub-collection.
6. Tap your own listing's "Chat Seller" → it politely blocks
   you ("This is your own listing").

---

## ⚠️ Note on Firestore security rules

If your Firestore is still in **test mode** from Phase 7, chat
works immediately. Test mode expires after 30 days. When you
later tighten rules, make sure signed-in users can read/write
the `chats` collection, e.g.:

```
match /chats/{chatId} {
  allow read, write: if request.auth != null;
  match /messages/{messageId} {
    allow read, write: if request.auth != null;
  }
}
```

For this assignment, test mode is fine — just mention it in
your demo notes.

---

## Known limitation (honest note for your demo)

- Chat has **no "unread" badge** and **no push notifications** —
  you see new messages when the Messages screen or a thread is
  open. Push notifications were listed as a separate possible
  feature; they need extra setup (Firebase Cloud Messaging) and
  are not part of Phase 9.
- Seeded demo products (P001–P004) have placeholder seller IDs,
  so chatting on them won't reach a real inbox. Use a freshly
  **posted** product for a real two-account test.

---

## Phase progress

| Phase | Feature | Status |
|-------|---------|--------|
| 1–5 | UI, Provider, Hive, image picker, favorites | ✅ Done |
| 6 | Firebase Authentication | ✅ Done |
| 7 | Firebase Firestore | ✅ Done |
| 8 | Firebase Storage | ✅ Done |
| 9 | **Real-time chat** ← you are here | ✅ Done |
| 10 | Polish, app icon, build APK | ⏳ Next |

When Phase 9 runs on your machine, say **"continue to Phase 10"**.
