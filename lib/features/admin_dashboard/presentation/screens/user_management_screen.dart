import 'package:cicoattendance/features/admin_dashboard/presentation/controllers/user_management_controller.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/widgets/admin_user_form.dart';
import 'package:cicoattendance/features/admin_dashboard/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userManagementControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (users) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserCard(user: user);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create New User'),
        content: SingleChildScrollView(
          child: AdminUserForm(
            onSubmit: (data) async {
              final controller =
                  ref.read(userManagementControllerProvider.notifier);
              final result = await controller.createUser(data);
              if (!context.mounted) return; // ✅ safe check
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      result ? '✅ User created' : '❌ Failed to create user'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
