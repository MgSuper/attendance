import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSummaryDialog(
  BuildContext context,
  List<AdminAttendanceLogModel> logs,
  Set<String> holidays, // 👈 Add this param
) async {
  final checkIns = logs.where((e) => e.type == 'check_in').length;
  final checkOuts = logs.where((e) => e.type == 'check_out').length;
  final late =
      logs.where((e) => e.type == 'check_in' && e.reason != null).length;
  final absents = await calculateAbsentDays(logs: logs, holidays: holidays);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Summary"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✅ Check-ins'),
              Text("$checkIns"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏳ Check-outs'),
              Text("$checkOuts"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🕒 Late entries'),
              Text("$late"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('❌ Absents'),
              Text("$absents"),
            ],
          ),
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

Future<int> calculateAbsentDays({
  required List<AdminAttendanceLogModel> logs,
  required Set<String> holidays,
}) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Format logs to yyyy-MM-dd strings
  final checkInDays = logs
      .where((e) => e.type == 'check_in')
      .map((e) => DateFormat('yyyy-MM-dd').format(e.timestamp.toDate()))
      .toSet();

  final workingDays = <String>{};

  for (int i = 1; i <= today.day; i++) {
    final day = DateTime(today.year, today.month, i);
    final key = DateFormat('yyyy-MM-dd').format(day);

    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    final isHoliday = holidays.contains(key);

    if (!isWeekend && !isHoliday) {
      workingDays.add(key);
    }
  }

  return workingDays.difference(checkInDays).length;
}
