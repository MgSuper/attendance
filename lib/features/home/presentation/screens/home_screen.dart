import 'package:cicoattendance/features/admin_dashboard/presentation/screens/admin_dashboard_screen.dart';
import 'package:cicoattendance/features/attendance_record/presentation/screens/attendance_record_screen.dart';
import 'package:cicoattendance/features/check_io/presentation/screens/check_io_screen.dart';
import 'package:cicoattendance/features/profile/presentation/screens/profile_screen.dart';
import 'package:cicoattendance/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (user) {
        final isAdmin = user.role == 'admin';
        print('Current index: ${currentIndex.value}, isAdmin: $isAdmin');

        final tabs = [
          if (!isAdmin)
            (
              widget: const CheckIOScreen(),
              item: const BottomNavigationBarItem(
                icon: Icon(Icons.fingerprint),
                label: 'Check-In',
              ),
            ),
          if (!isAdmin)
            (
              widget: const AttendanceRecordScreen(),
              item: const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Records',
              ),
            ),
          if (isAdmin)
            (
              widget: const AdminDashboardScreen(),
              item: const BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
              ),
            ),
          (
            widget: const ProfileScreen(),
            item: const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ),
        ];

        print('Tabs length: ${tabs.length}');
        // Reset index if it exceeds available tab count
        if (currentIndex.value >= tabs.length) {
          currentIndex.value = 0;
        }

        return Scaffold(
          body: tabs[currentIndex.value].widget,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            items: tabs.map((e) => e.item).toList(),
          ),
        );
      },
    );
  }
}
