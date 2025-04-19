import 'package:cicoattendance/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:cicoattendance/features/home/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      final loggingIn = state.matchedLocation == '/sign-in';

      if (user == null && !loggingIn) return '/sign-in';
      if (user != null && loggingIn) return '/home';
      return null;
    },
    initialLocation: '/sign-in',
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
