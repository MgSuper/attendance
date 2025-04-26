import 'package:cicoattendance/core/theme/theme_provider.dart';
import 'package:cicoattendance/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final themeNotifier = ref.read(themeModeNotifierProvider.notifier);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (user) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, child: Icon(Icons.person)),
                    const SizedBox(height: 12),
                    Text(user.name ?? 'Unknown',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(user.email,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _tile('Company ID', user.companyId ?? '-'),
              _tile('Department', user.department ?? '-'),
              _tile('Position', user.position ?? '-'),
              _tile('Join Date', user.joinDate ?? '-'),
              _tile('Role', user.role),
              _tile('Last Check-In', user.lastCheckIn ?? '-'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Theme Mode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(themeMode.name.toUpperCase()),
                trailing: const Icon(Icons.brightness_6),
                onTap: () => themeNotifier.cycle(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
