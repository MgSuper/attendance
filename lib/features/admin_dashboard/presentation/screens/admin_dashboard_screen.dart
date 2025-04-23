// import 'dart:io';

// import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
// import 'package:cicoattendance/features/admin_dashboard/presentation/controllers/admin_filter_controller.dart';
// import 'package:cicoattendance/features/admin_dashboard/presentation/providers/admin_logs_provider.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class AdminDashboardScreen extends ConsumerWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final logsAsync = ref.watch(allAttendanceLogsProvider);
//     final filters = ref.watch(adminFilterControllerProvider.notifier);
//     final selected = ref.watch(adminFilterControllerProvider);

//     String _convertLogsToCsv(List<AdminAttendanceLog> logs) {
//       final buffer = StringBuffer();
//       buffer.writeln("User ID,Type,Timestamp,Lat,Lng,Distance (m),Reason");

//       for (final log in logs) {
//         final date = log.timestamp.toDate().toIso8601String();
//         buffer.writeln(
//           '${log.uid},${log.type},$date,${log.lat},${log.lng},${log.distance},${log.reason ?? ""}',
//         );
//       }

//       return buffer.toString();
//     }

//     Future<File> _writeCsvToFile(String csv) async {
//       final dir = await getTemporaryDirectory();
//       final path = '${dir.path}/attendance_logs.csv';
//       final file = File(path);
//       return await file.writeAsString(csv);
//     }

//     Future<File> generateAttendanceExcel(List<AdminAttendanceLog> logs) async {
//       final excel = Excel.createExcel();
//       final sheet = excel['Attendance Logs'];

//       // Header
//       sheet.appendRow([
//         TextCellValue('User ID'),
//         TextCellValue('Type'),
//         TextCellValue('Timestamp'),
//         TextCellValue('Latitude'),
//         TextCellValue('Longitude'),
//         TextCellValue('Distance (m)'),
//         TextCellValue('Reason')
//       ]);

//       // Data rows
//       for (final log in logs) {
//         sheet.appendRow([
//           TextCellValue(log.uid),
//           TextCellValue(log.type),
//           TextCellValue(log.timestamp.toDate().toIso8601String()),
//           TextCellValue(log.lat.toStringAsFixed(6)),
//           TextCellValue(log.lng.toStringAsFixed(6)),
//           TextCellValue(log.distance.toStringAsFixed(2)),
//           TextCellValue(log.reason ?? ''),
//         ]);
//       }

//       // Save to file
//       final dir = await getTemporaryDirectory();
//       final filePath = '${dir.path}/attendance_logs.xlsx';
//       final fileBytes = excel.encode()!;
//       final file = File(filePath)..createSync(recursive: true);
//       await file.writeAsBytes(fileBytes);

//       return file;
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Logs')),
//       body: logsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) {
//           print('error: $e');
//           return Center(child: Text('Error: $e'));
//         },
//         data: (logs) {
//           if (logs.isEmpty) {
//             return const Center(child: Text('No logs found.'));
//           }

//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () async {
//                         final picked = await showDatePicker(
//                           context: context,
//                           initialDate: selected.$1 ?? DateTime.now(),
//                           firstDate: DateTime(2023),
//                           lastDate:
//                               DateTime.now().add(const Duration(days: 365)),
//                         );
//                         filters.setDate(picked);
//                       },
//                       icon: const Icon(Icons.calendar_today),
//                       label: Text(
//                         selected.$1 != null
//                             ? "${selected.$1!.toLocal()}".split(" ")[0]
//                             : "Filter by Date",
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: TextField(
//                         onChanged: filters.setUserId,
//                         decoration: const InputDecoration(
//                           labelText: 'Filter by UID',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.download),
//                 label: const Text("Export to CSV"),
//                 onPressed: () async {
//                   final logs = ref.read(allAttendanceLogsProvider).value;
//                   if (logs == null || logs.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("No data to export")),
//                     );
//                     return;
//                   }

//                   final csv = _convertLogsToCsv(logs);
//                   final excelFile = await generateAttendanceExcel(logs);
//                   await Share.shareXFiles([XFile(excelFile.path)],
//                       text: 'Attendance Logs');
//                 },
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: ListView.separated(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: logs.length,
//                   separatorBuilder: (_, __) => const Divider(),
//                   itemBuilder: (context, index) {
//                     final log = logs[index];
//                     final time = log.timestamp.toDate();

//                     return ListTile(
//                       leading: Icon(
//                           log.type == 'check_in' ? Icons.login : Icons.logout),
//                       title: Text('${log.type.toUpperCase()} - ${log.uid}'),
//                       subtitle: Text(
//                         '${time.toLocal()}'
//                         '\nLatLng: ${log.lat.toStringAsFixed(5)}, ${log.lng.toStringAsFixed(5)}'
//                         '\nDistance: ${log.distance.toStringAsFixed(2)} m'
//                         '${log.reason != null ? '\nReason: ${log.reason}' : ''}',
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cicoattendance/features/admin_dashboard/presentation/controllers/user_list_controller.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminDashboardScreen extends HookConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (users) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final user = users[index];
            return UserListItem(
              user: user,
              onTap: () => context.push('/admin/user/${user.uid}'),
            );
          },
        ),
      ),
    );
  }
}
