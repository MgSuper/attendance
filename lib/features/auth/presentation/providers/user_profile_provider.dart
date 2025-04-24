import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_provider.g.dart';

class UserProfile {
  final String name;
  final String email;
  final String role;

  const UserProfile({
    required this.name,
    required this.email,
    required this.role,
  });
}

@riverpod
Future<UserProfile> userProfile(Ref ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception('User not signed in');

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data()!;
  print('data: $data');

  return UserProfile(
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    role: data['role'] ?? 'user',
  );
}
