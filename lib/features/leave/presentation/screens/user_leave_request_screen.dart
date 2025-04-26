import 'package:cicoattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:cicoattendance/features/leave/presentation/controllers/leave_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class UserLeaveRequestsScreen extends HookConsumerWidget {
  const UserLeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final leaveRequestsAsync = ref.watch(leaveRequestControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Leave Requests'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await context.push<bool>('/leave/request');
              if (result == true) {
                // ✅ After successfully adding new leave, refresh list
                ref.invalidate(leaveRequestControllerProvider);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: leaveRequestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (requests) {
          final userRequests = requests
              .where((r) => r.userId == user?.uid)
              .toList(); // ✅ Filter user's own requests

          if (userRequests.isEmpty) {
            return const Center(child: Text('No leave requests yet.'));
          }

          return ListView.builder(
            itemCount: userRequests.length,
            itemBuilder: (context, index) {
              final leave = userRequests[index];
              final statusColor = _statusColor(leave.status);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    '${DateFormat.yMMMd().format(leave.startDate)} → ${DateFormat.yMMMd().format(leave.endDate)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason: ${leave.reason}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              leave.status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (leave.status == 'rejected' &&
                              leave.rejectedReason != null)
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '🛑 Reason: ${leave.rejectedReason!}',
                                  style:
                                      const TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
