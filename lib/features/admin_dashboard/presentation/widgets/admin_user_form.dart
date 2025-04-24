import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AdminUserForm extends HookWidget {
  final void Function(Map<String, dynamic> data) onSubmit;

  const AdminUserForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final companyId = useTextEditingController();
    final department = useState('Engineering');
    final position = useTextEditingController();
    final role = useState('user');

    final departments = ['Engineering', 'Sales', 'HR', 'Marketing'];
    final roles = ['user', 'admin'];

    return Form(
      child: Column(
        children: [
          TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Full Name')),
          TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email')),
          TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true),
          TextField(
              controller: companyId,
              decoration: const InputDecoration(labelText: 'Company ID')),
          TextField(
              controller: position,
              decoration: const InputDecoration(labelText: 'Position')),
          DropdownButtonFormField<String>(
            value: department.value,
            onChanged: (val) => department.value = val!,
            items: departments
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            decoration: const InputDecoration(labelText: 'Department'),
          ),
          DropdownButtonFormField<String>(
            value: role.value,
            onChanged: (val) => role.value = val!,
            items: roles
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            decoration: const InputDecoration(labelText: 'Role'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Create User'),
            onPressed: () {
              final formData = {
                'name': name.text.trim(),
                'email': email.text.trim(),
                'password': password.text.trim(),
                'company_id': companyId.text.trim(),
                'department': department.value,
                'position': position.text.trim(),
                'role': role.value,
              };
              onSubmit(formData);
            },
          ),
        ],
      ),
    );
  }
}
