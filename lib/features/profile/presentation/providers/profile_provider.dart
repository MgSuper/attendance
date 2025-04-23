import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cicoattendance/features/profile/data/repository/profile_repository_impl.dart';
import 'package:cicoattendance/features/profile/domain/entities/user_entity.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserEntity> userProfile(Ref ref) async {
  final authUser = FirebaseAuth.instance.currentUser;
  if (authUser == null) throw Exception("No signed-in user");

  final repo = ProfileRepositoryImpl(FirebaseFirestore.instance);
  return repo.getUserProfile(authUser.uid);
}
