import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSummaryDialog(
    BuildContext context, List<AdminAttendanceLogModel> logs) {
  final checkIns = logs.where((e) => e.type == 'check_in').toList();
  final checkOuts = logs.where((e) => e.type == 'check_out').toList();

  final lateCheckIns = checkIns.where((e) {
    final dt = e.timestamp.toDate();
    return dt.hour > 9 || (dt.hour == 9 && dt.minute > 0);
  }).toList();

  final totalWorkMinutes = <int>[];
  final groupedByDay = <String, Map<String, AdminAttendanceLogModel>>{};

  for (final e in logs) {
    final dateKey = DateFormat('yyyy-MM-dd').format(e.timestamp.toDate());
    groupedByDay.putIfAbsent(dateKey, () => {});
    groupedByDay[dateKey]![e.type] = e;
  }

  for (final entry in groupedByDay.values) {
    final checkIn = entry['check_in'];
    final checkOut = entry['check_out'];

    if (checkIn != null) {
      final start = checkIn.timestamp.toDate();
      final end =
          DateTime(start.year, start.month, start.day, 17, 0); // up to 5PM
      final diff = end.difference(start);
      if (!diff.isNegative) {
        totalWorkMinutes.add(diff.inMinutes);
      }
    }
  }

  final totalHoursWorked = totalWorkMinutes.fold(0, (sum, m) => sum + m) / 60;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Monthly Summary"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("✅ Total Check-Ins: ${checkIns.length}"),
          Text("✅ Total Check-Outs: ${checkOuts.length}"),
          Text("⏰ Late Check-Ins: ${lateCheckIns.length}"),
          Text("📅 Absent Days: ${_calculateAbsentDays(logs)}"),
          Text(
              "🕒 Total Hours Worked: ${totalHoursWorked.toStringAsFixed(1)}h"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    ),
  );
}

int _calculateAbsentDays(List<AdminAttendanceLogModel> logs) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final checkInsByDay = logs
      .where((e) => e.type == 'check_in')
      .map((e) => DateFormat('yyyy-MM-dd').format(e.timestamp.toDate()))
      .toSet();

  final workingDays = <String>{};

  for (int i = 1; i <= today.day; i++) {
    final day = DateTime(today.year, today.month, i);

    // Skip Saturdays and Sundays
    if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
      continue;
    }

    final key = DateFormat('yyyy-MM-dd').format(day);
    workingDays.add(key);
  }

  return workingDays.difference(checkInsByDay).length;
}
