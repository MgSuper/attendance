import 'package:cicoattendance/features/admin_dashboard/presentation/screens/user_attendance_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cicoattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:cicoattendance/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cicoattendance/features/home/presentation/screens/home_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    redirect: (context, state) {
      final user = authState.asData?.value;
      final isLoggingIn = state.matchedLocation == '/sign-in';

      if (user == null && !isLoggingIn) return '/sign-in';
      if (user != null && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/admin/user/:uid',
        builder: (context, state) {
          final uid = state.pathParameters['uid']!;
          return UserAttendanceScreen(uid: uid); // 👈 New screen
        },
      ),
    ],
  );
});
