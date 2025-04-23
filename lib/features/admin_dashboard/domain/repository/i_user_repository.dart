import 'package:cicoattendance/features/admin_dashboard/data/models/admin_user_model.dart';

abstract class IUserRepository {
  Future<List<AdminUserModel>> getAllUsers();
}
