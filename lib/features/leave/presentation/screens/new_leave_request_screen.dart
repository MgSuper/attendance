import 'package:cicoattendance/features/leave/presentation/controllers/leave_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class NewLeaveRequestScreen extends HookConsumerWidget {
  const NewLeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final reasonController = useTextEditingController();

    final loading = useState(false);
    final controller = ref.read(leaveRequestControllerProvider.notifier);

    Future<void> _submit() async {
      if (startDate.value == null ||
          endDate.value == null ||
          reasonController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ All fields are required')),
        );
        return;
      }

      loading.value = true;

      final success = await controller.submitLeave(
        startDate: startDate.value!,
        endDate: endDate.value!,
        reason: reasonController.text.trim(),
      );

      loading.value = false;

      if (!context.mounted) return; // ✅ safe check

      if (success) {
        reasonController.clear();
        startDate.value = null;
        endDate.value = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Leave request submitted')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('❌ You already submitted a leave request.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _DatePickerField(
              label: 'Start Date',
              date: startDate.value,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) startDate.value = picked;
              },
            ),
            const SizedBox(height: 12),
            _DatePickerField(
              label: 'End Date',
              date: endDate.value,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: startDate.value ?? DateTime.now(),
                  firstDate: startDate.value ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) endDate.value = picked;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loading.value ? null : _submit,
              icon: loading.value
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.send),
              label: const Text('Submit Request'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(
        date != null ? DateFormat.yMMMd().format(date!) : 'Select date',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }
}
