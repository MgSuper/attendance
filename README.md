# ✅ Check-In/Check-Out Attendance App

A modern Flutter app using **Riverpod + Clean Architecture**, connected to **Firebase Auth & Firestore** for employee check-in/check-out tracking, attendance records, and admin controls.

---

## 🔥 Features

### 👤 User View

- 📲 Email/password sign-in (accounts pre-created via Firebase Console)
- 📍 Check-in when within 10m of office location
- ⏰ Time-based rules (e.g., check-in after 8:30, check-out after 17:00)
- 📝 Late check-in requires reason input
- 🗓️ Public holiday + weekend awareness
- 🧭 Location-aware buttons with loading shimmer and error handling
- 🧾 View personal attendance history

### 🛠️ Admin View

- 👥 View all users
- 📅 Tap user to view monthly attendance
- 📂 Filter logs by month
- 📤 Export filtered logs to CSV
- 📊 Summary report (check-ins, absents, late days, total hours)
- ➕ Add new users (manual UID setup)
- 🏖 Supports public holiday config

---

## 📦 Tech Stack

- Flutter 3.19+
- Firebase Auth + Firestore
- Riverpod 2.x (`@riverpod` codegen + `hooks_riverpod`)
- GoRouter with auth guards
- MultipleResult for clean error handling
- Shimmer loading UI
- CSV export support
- Clean architecture pattern

---

## 🧭 Sample Folder Structure

lib/
├── core/
├── router/
├── features/
└── auth/
├── domain/
├── data/
└── presentation/
└── main.dart

## 🧪 Run Tests

```bash
flutter test                # Unit + Widget tests
flutter test integration_test  # Integration tests
```

🔐 Firebase Setup
Create Firebase project

Enable Email/Password Auth

Pre-create users in Firebase Auth

Create Firestore collections:

users/{uid} with role & profile info

config/office with check-in rules + location

holidays/{YYYY-MM-DD} for public holidays

Add config files:

android/app/google-services.json

ios/Runner/GoogleService-Info.plist

⚙️ CI/CD
Using GitHub Actions:

✅ flutter analyze

✅ flutter test

✅ integration_test

Workflow file: .github/workflows/flutter_test.yml

🌗 Theme Support
🌞 Light

🌙 Dark

🖤 AMOLED Black

User can toggle from Profile Screen.

✨ Extras
🔒 Role-based routing (user vs admin)

🧠 Reactive auth state w/ Riverpod

🎯 Location + time-based attendance

🛠️ Admin-exportable reports (CSV)

🗓️ Absence excludes holidays + weekends

🪄 Dynamic shimmer placeholder components
