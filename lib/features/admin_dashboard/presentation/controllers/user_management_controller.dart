import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cicoattendance/features/profile/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/profile/data/models/user_model.dart';

part 'user_management_controller.g.dart';

@riverpod
class UserManagementController extends _$UserManagementController {
  @override
  Future<List<UserEntity>> build() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final users = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data(), doc.id))
        .where((user) => user.uid != currentUid) // exclude self
        .map((e) => e.toEntity())
        .toList();

    return users;
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('users');

      // Generate a new random UID (simulate one from Firebase Auth)
      final newDocRef = userCollection.doc();

      await newDocRef.set({
        'email': data['email'],
        'name': data['name'],
        'company_id': data['company_id'],
        'department': data['department'],
        'position': data['position'],
        'role': data['role'],
        'join_date': DateTime.now().toIso8601String(),
        'last_check_in': null,
      });

      // Refresh UI
      state = const AsyncLoading();
      state = AsyncData(await build());

      return true;
    } catch (e) {
      print("createUser error: $e");
      return false;
    }
  }
}
