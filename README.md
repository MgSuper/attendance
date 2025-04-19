# ✅ Check-In/Check-Out Attendance App

This is a Flutter app built using **Riverpod + Clean Architecture**, connected to **Firebase** for authentication and check-in/check-out attendance tracking.

## 🔥 Features

- 📲 Firebase Email/Password sign-in (users are pre-created)
- 🧠 Clean architecture (domain → data → presentation)
- 🚀 Routing via `go_router` with auth guards
- 🎯 State management with `hooks_riverpod` and `@riverpod` codegen
- 💡 Error handling via `multiple_result`
- ✅ Fully tested: unit, widget, and integration tests
- ⚙️ GitHub Actions CI setup

## 📦 Tech Stack

- Flutter 3.19+
- Firebase Auth & Firestore
- Riverpod 2.x with `riverpod_generator`
- GoRouter
- Shimmer
- multiple_result
- Clean architecture pattern

## 📁 Folder Structure

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
