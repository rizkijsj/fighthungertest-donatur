# FightHunger Donatur Android migration

This directory is an Android Studio Kotlin project migrated from the Swift iOS project.

## Setup
1. Open `android-kotlin` in Android Studio.
2. Download `google-services.json` from the Firebase project and put it in `android-kotlin/app/`.
3. Enable Phone Authentication, Realtime Database, Storage, and Cloud Messaging in Firebase.
4. Sync Gradle and run `app`.

The Firebase paths match the iOS implementation: `users/donatur/profile`, `users/phonenumber`, `users/komunitas`, `PublicPost`, `UsersPost`, `Riwayat/User`, and `users/fcmtoken`.

`google-services.json` and signing credentials are intentionally not committed.
