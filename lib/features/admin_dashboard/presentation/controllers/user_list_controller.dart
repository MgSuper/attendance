import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/admin_user_model.dart';
import '../../data/repository/user_repository_impl.dart';

part 'user_list_controller.g.dart';

@riverpod
Future<List<AdminUserModel>> allUsers(Ref ref) async {
  final repo = UserRepositoryImpl();
  return repo.getAllUsers();
}
