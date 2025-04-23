import 'package:cicoattendance/features/admin_dashboard/data/models/admin_user_model.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final AdminUserModel user;
  final VoidCallback onTap;

  const UserListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(user.name ?? 'Unknown'),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
