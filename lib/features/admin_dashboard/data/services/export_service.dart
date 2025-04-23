import 'dart:io';
import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportToCsv({
    required String userName,
    required List<AdminAttendanceLogModel> logs,
  }) async {
    final rows = <List<String>>[
      ['Date', 'Time', 'Type', 'Distance (m)', 'Late Reason'],
      for (final log in logs)
        [
          DateFormat('yyyy-MM-dd').format(log.timestamp.toDate()),
          DateFormat('HH:mm').format(log.timestamp.toDate()),
          log.type,
          log.distance?.toStringAsFixed(2) ?? '-',
          log.reason ?? '-',
        ]
    ];

    final csvData = const ListToCsvConverter().convert(rows);

    await Permission.storage.request(); // May be skipped on iOS

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$userName-attendance.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    print("✅ CSV exported to: $path");

    // 🔄 Share the file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: '📊 $userName attendance records attached.',
      subject: '$userName Attendance Logs',
    );
  }
}
