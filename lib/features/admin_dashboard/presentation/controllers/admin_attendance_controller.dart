import 'package:cicoattendance/features/admin_dashboard/data/services/export_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../admin_dashboard/data/models/admin_attendance_log_model.dart';

part 'admin_attendance_controller.g.dart';

@riverpod
class UserAttendance extends _$UserAttendance {
  @override
  Future<List<AdminAttendanceLogModel>> build(
      String uid, DateTime selectedMonth) async {
    final start = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final end = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('attendance_logs')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp')
        .get();

    return snapshot.docs
        .map((doc) => AdminAttendanceLogModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> exportToCsv() async {
    final logs = await future;
    final name = await _getUserName(uid); // fetch user name
    ExportService.exportToCsv(userName: name, logs: logs);
  }

  Future<String> _getUserName(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final name = data?['name'] ?? 'user';
    return name.toString().toLowerCase().replaceAll(' ', '-');
  }
}

@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() => DateTime.now();
}
