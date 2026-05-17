# Phase 8 — Firebase Storage (Cloud Image Uploads)

> **Team:** DevDynasty
> **Goal:** Stop cramming product photos into Firestore
> documents. Upload them to **Firebase Storage** instead, and
> keep only a small image URL in Firestore.

---

## Why Phase 8 exists

In Phases 4–7, a product's photo was stored as raw bytes
(`imageBytes`) **inside the Firestore document**.

The problem: **Firestore documents have a hard 1 MB limit.**
A real phone photo is often 1–5 MB. So sooner or later, posting
a product with a photo would simply fail.

**Firebase Storage** is built for files (images, videos, PDFs).
Phase 8 changes the flow to:

```
Pick photo → upload bytes to Firebase Storage → get a URL
           → save the product to Firestore with just that URL
```

The Firestore document is now tiny (a URL is ~100 characters),
and there is no practical size limit on the photo.

---

## What changed in the code (already done)

| File | Change |
|------|--------|
| `lib/services/storage_service.dart` | **New.** Wraps Firebase Storage — `uploadProductImage()` and `deleteProductImage()`. The only new file. |
| `lib/providers/product_provider.dart` | Added `addProductWithImage()` (uploads photo, then saves product). `deleteProduct()` now also deletes the Storage image. |
| `lib/services/product_firestore_service.dart` | No longer writes `imageBytes` into Firestore documents — only `imageUrl`. |
| `lib/screens/add_listing_screen.dart` | Submitting a listing now uploads the photo to Storage. Button shows "Uploading photo...". |
| `lib/widgets/product_card.dart` | Thumbnails load from the Storage URL via `Image.network`. |
| `lib/screens/product_details_screen.dart` | Large image loads from the Storage URL. |
| `lib/models/product.dart` | Added `hasNetworkImage` getter. |
| `pubspec.yaml` | Added `firebase_storage`. |
| `android/.../AndroidManifest.xml` | Added the `INTERNET` permission. |

**Backward compatible:** old products that still have
`imageBytes` keep displaying — the UI tries the URL first, then
falls back to bytes, then to a category icon.

---

## Setup — 2 steps (about 5 minutes)

Firebase is already set up from Phases 6 & 7, so this is short.

### Step 1 — Enable Storage in the Firebase console

1. Go to **<https://console.firebase.google.com>** and open
   your **campuscart** project.
2. In the left menu: **Build → Storage**.
3. Click **Get started**.
4. A dialog appears about security rules — choose
   **Start in test mode** for now (fine for a student project;
   see the note below).
5. Pick a Cloud Storage location (any nearby region is fine —
   you cannot change it later).
6. Click **Done**.

### Step 2 — Install the package and run

```bash
cd campuscart
flutter pub get
flutter run
```

`flutter pub get` downloads the new `firebase_storage` package.
That's it — Phase 8 is live.

> You do **not** need to run `flutterfire configure` again.
> Storage uses the same Firebase project config that Auth and
> Firestore already use.

---

## How to test Phase 8 works

1. **Post a new listing with a photo.** The button shows
   "Uploading photo..." for a moment, then "posted successfully".
2. In the Firebase console → **Storage → Files**, open the
   `product_images/` folder — your uploaded `.jpg` file is
   there. That proves the photo went to the cloud.
3. In the console → **Firestore → products**, open the new
   product document. It has an `imageUrl` field (a long
   `https://firebasestorage...` link) and **no** `imageBytes`
   field. That proves the document stays small.
4. The new product's photo shows on the **home list** and the
   **details screen** (loaded from the URL).
5. **Delete** that product → check Storage again: the image
   file is gone too (no orphaned files).
6. Run the app on a **second device / browser** and sign in —
   the photo loads there too, because it's in the cloud.

---

## ⚠️ About "test mode" security rules

"Test mode" lets anyone read and write your Storage for 30 days.
That is fine for development and a class demo. Before any real
public release you would tighten the rules, e.g. only signed-in
users can upload. Example rule for later:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /product_images/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

For this assignment, leaving test mode on is acceptable — just
mention it in your demo notes.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Upload fails: "object does not exist" / permission denied | Storage not enabled, or rules expired. Redo Step 1. |
| `firebase_storage` not found on build | You skipped `flutter pub get`. Run it inside `campuscart/`. |
| Photo doesn't show, shows category icon instead | The `imageUrl` failed to load — check the file exists in Storage → Files. The icon fallback is working as designed. |
| Old products show no photo | Expected if they were seeded without one. New uploads will show. |

---

## Phase progress

| Phase | Feature | Status |
|-------|---------|--------|
| 1–5 | UI, Provider, Hive, image picker, favorites | ✅ Done |
| 6 | Firebase Authentication | ✅ Done |
| 7 | Firebase Firestore | ✅ Done |
| 8 | **Firebase Storage** ← you are here | ✅ Done |
| 9 | Real-time chat between buyers & sellers | ⏳ Next |
| 10 | Polish, app icon, build APK | ⏳ Planned |

When Phase 8 runs on your machine, say **"continue to Phase 9"**.
