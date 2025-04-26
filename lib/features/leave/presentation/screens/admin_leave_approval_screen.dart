import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/presentation/controllers/leave_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AdminLeaveApprovalScreen extends HookConsumerWidget {
  const AdminLeaveApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveAsync = ref.watch(leaveRequestControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Approvals')),
      body: leaveAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No leave requests.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(request.userName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'From: ${DateFormat.yMMMd().format(request.startDate)} → ${DateFormat.yMMMd().format(request.endDate)}'),
                      const SizedBox(height: 4),
                      Text('Reason: ${request.reason}'),
                      const SizedBox(height: 4),
                      Text('Status: ${request.status.toUpperCase()}'),
                      if (request.status == 'rejected' &&
                          request.rejectedReason != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('🛑 Reason: ${request.rejectedReason!}',
                              style: const TextStyle(color: Colors.red)),
                        ),
                      if (request.status == 'pending')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _approve(ref, request),
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Colors.green,
                              //   minimumSize: const Size(100, 36),
                              // ),
                              icon: Icon(Icons.check_box),
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              onPressed: () => _reject(context, ref, request),
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Colors.red,
                              //   minimumSize: const Size(100, 36),
                              // ),
                              icon: Icon(Icons.close),
                            ),
                          ],
                        )
                    ],
                  ),
                  isThreeLine: true,
                  // trailing: _ActionButtons(request: request),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _approve(WidgetRef ref, LeaveRequestEntity request) async {
    await ref
        .read(leaveRequestControllerProvider.notifier)
        .updateStatus(request.id, 'approved');
  }

  Future<void> _reject(
      BuildContext context, WidgetRef ref, LeaveRequestEntity request) async {
    final reason = await _showRejectReasonDialog(context);
    if (reason == null || reason.trim().isEmpty) return;

    print('reason 1 : $reason');

    await ref
        .read(leaveRequestControllerProvider.notifier)
        .updateStatus(request.id, 'rejected', rejectedReason: reason.trim());
  }

  Future<String?> _showRejectReasonDialog(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Reason'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter reason for rejection',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text.trim());
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

// class _ActionButtons extends ConsumerWidget {
//   final LeaveRequestEntity request;

//   const _ActionButtons({required this.request});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     if (request.status != 'pending') {
//       return const SizedBox.shrink();
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         IconButton(
//           onPressed: () => _approve(ref, request),
//           // style: ElevatedButton.styleFrom(
//           //   backgroundColor: Colors.green,
//           //   minimumSize: const Size(100, 36),
//           // ),
//           icon: Icon(Icons.check_box),
//         ),
//         const SizedBox(height: 8),
//         IconButton(
//           onPressed: () => _reject(context, ref, request),
//           // style: ElevatedButton.styleFrom(
//           //   backgroundColor: Colors.red,
//           //   minimumSize: const Size(100, 36),
//           // ),
//           icon: Icon(Icons.close),
//         ),
//       ],
//     );
//   }

// }
