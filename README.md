# ✅ Check-In/Check-Out Attendance + Leave Request App

A complete company attendance management system built with **Flutter + Firebase + Riverpod + Clean Architecture**.

## 🔥 Features

### 🚪 Authentication

- Firebase Email/Password login (users pre-created)
- Logout button on profile page
- Fully reactive login flow using Riverpod + GoRouter

### 🕐 Attendance Management

- Location-based Check-In / Check-Out (within 10 meters)
- Time-based rules:
  - Check-In: 8:30 AM - 5:00 PM
  - Late if after 9:00 AM (reason required)
  - Check-Out: 5:00 PM - Next Day 8:30 AM
- Weekend and Public Holidays:
  - No check-in allowed
  - Shows 🎉 "We don't work on holidays!"
- Real-time Check-In/Out button state updates
- Shimmer loading while fetching location and configs

### 📊 Admin Dashboard

- View all users
- Tap user to see monthly attendance
- Monthly filter
- Export attendance logs to CSV
- Attendance Summary:
  - Total Check-Ins
  - Total Check-Outs
  - Late Days
  - Absents

### 👨‍💼 User Management (Admin)

- View all registered users
- Create new users via Admin Panel
- Assign user details (company, department, role)

### 📅 Public Holidays

- Firestore collection for holidays
- Holidays automatically block check-in/check-out

### 📝 Leave Request Management

- Users:
  - Submit leave request (start date, end date, reason)
  - See list of their requests (pending, approved, rejected)
  - Rejected reason visible
- Admin:
  - Approve / Reject leave requests
  - Provide reject reason when rejecting
- Full history tracking and filtering

---

## 📦 Tech Stack

- Flutter 3.19+
- Firebase Auth & Firestore
- Riverpod 2.x + riverpod_annotation
- GoRouter
- Flutter Hooks
- Shimmer for loading states
- multiple_result for error handling
- Clean architecture: `domain → data → presentation`

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

leave_requests for leave request and management by admin

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

📝 Leave request by user + approve reject by admin

🪄 Dynamic shimmer placeholder components
