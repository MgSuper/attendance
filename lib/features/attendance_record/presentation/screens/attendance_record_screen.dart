import 'package:cicoattendance/common/widgets/shimmer/shimmer_list_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_log_provider.dart';

class AttendanceRecordScreen extends HookConsumerWidget {
  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(attendanceLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
        centerTitle: false,
      ),
      body: logsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ShimmerListPlaceholder(itemCount: 6, itemHeight: 70),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) => logs.isEmpty
            ? const Center(child: Text('No records found.'))
            : ListView.separated(
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final date = DateFormat('yyyy-MM-dd – kk:mm')
                      .format(log.timestamp.toDate());

                  return ListTile(
                    leading: Icon(
                      log.type == 'check_in' ? Icons.login : Icons.logout,
                      color:
                          log.type == 'check_in' ? Colors.green : Colors.blue,
                    ),
                    title: Text('${log.type.toUpperCase()} at $date'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lat: ${log.lat}, Lng: ${log.lng}'),
                        Text(
                            'Distance: ${log.distanceFromTarget.toStringAsFixed(1)} m'),
                        if (log.reason != null && log.reason!.isNotEmpty)
                          Text('Reason: ${log.reason}'),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
