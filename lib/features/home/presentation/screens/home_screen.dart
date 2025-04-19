import 'package:cicoattendance/features/auth/presentation/controllers/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(signInControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => notifier.signOut(),
          ),
        ],
      ),
      body: const Center(child: Text("Welcome")),
    );
  }
}
