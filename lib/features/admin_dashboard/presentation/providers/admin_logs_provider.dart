// import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../controllers/admin_filter_controller.dart';

// final allAttendanceLogsProvider =
//     FutureProvider<List<AdminAttendanceLog>>((ref) async {
//   final (date, userId) = ref.watch(adminFilterControllerProvider);

//   Query<Map<String, dynamic>> query =
//       FirebaseFirestore.instance.collectionGroup('attendance_logs');

//   if (date != null) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(const Duration(days: 1));
//     query = query
//         .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
//         .where('timestamp', isLessThan: Timestamp.fromDate(end));
//   }

//   if (userId != null && userId.isNotEmpty) {
//     // Use where filter on UID if flattened to collection
//     // Otherwise filter after fetching (client-side)
//     final raw = await query.orderBy('timestamp', descending: true).get();
//     return raw.docs
//         .where((doc) => doc.reference.parent.parent?.id == userId)
//         .map((doc) => AdminAttendanceLog.fromFirestore(doc))
//         .toList();
//   }

//   final snapshot = await query.orderBy('timestamp', descending: true).get();
//   return snapshot.docs
//       .map((doc) => AdminAttendanceLog.fromFirestore(doc))
//       .toList();
// });
