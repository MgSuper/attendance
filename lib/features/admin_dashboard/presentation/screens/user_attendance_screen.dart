import 'package:cicoattendance/features/admin_dashboard/data/models/admin_attendance_log_model.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/controllers/admin_attendance_controller.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/providers/holidays_provider.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/widgets/summary_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Declare once
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

class UserAttendanceScreen extends HookConsumerWidget {
  final String uid;
  const UserAttendanceScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final logsAsync = ref.watch(userAttendanceProvider(uid, selectedMonth));
    final holidaysAsync = ref.watch(holidayDatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          if (logsAsync.hasValue)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                await ref
                    .read(userAttendanceProvider(uid, selectedMonth).notifier)
                    .exportToCsv();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Exported to CSV')),
                  );
                }
              },
            ),
        ],
      ),
      body: holidaysAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading holidays: $e')),
        data: (holidays) {
          return logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (logs) => Column(
              children: [
                _MonthPicker(
                  selected: selectedMonth,
                  logs: logs,
                  holidays: holidays,
                  onChange: (newMonth) {
                    if (newMonth != null) {
                      ref.read(selectedMonthProvider.notifier).state = newMonth;
                    }
                  },
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final isCheckIn = log.type == 'check_in';
                      final dt = log.timestamp.toDate();
                      return ListTile(
                        leading: Icon(
                          isCheckIn ? Icons.login : Icons.logout,
                          color: isCheckIn ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          '${DateFormat.yMMMd().format(dt)} • ${DateFormat.Hm().format(dt)}',
                        ),
                        subtitle: Text(
                          isCheckIn
                              ? 'Checked in${log.reason != null ? ' 🕒 Reason: ${log.reason}' : ''}'
                              : 'Checked out',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthPicker extends StatelessWidget {
  final DateTime selected;
  final List<AdminAttendanceLogModel> logs;
  final Set<String> holidays;
  final ValueChanged<DateTime?>? onChange;

  const _MonthPicker({
    required this.selected,
    required this.logs,
    required this.holidays,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    final items = List.generate(12, (index) {
      final date = DateTime(year, index + 1);
      return DropdownMenuItem<DateTime>(
        value: date,
        child: Text(DateFormat.MMMM().format(date)),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Month:'),
          const SizedBox(width: 8),
          DropdownButton<DateTime>(
            value: DateTime(selected.year, selected.month),
            items: items,
            onChanged: onChange,
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              showSummaryDialog(context, logs, holidays);
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('Summary'),
          ),
        ],
      ),
    );
  }
}
