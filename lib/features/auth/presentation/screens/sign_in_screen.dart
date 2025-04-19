import 'package:cicoattendance/features/auth/presentation/controllers/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final controller = ref.watch(signInControllerProvider);
    final notifier = ref.read(signInControllerProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // Header
          const Positioned(
            top: 150,
            left: 32,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Centered form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (controller.hasError)
                    Text("Error: ${controller.error}",
                        style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),

          // Button at bottom of form
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: 32,
            right: 32,
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => notifier.signIn(email.text, password.text),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text("SIGN IN"),
                  ),
          ),
        ],
      ),
    );
  }
}
