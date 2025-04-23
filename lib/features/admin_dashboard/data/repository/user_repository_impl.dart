import 'package:cicoattendance/features/admin_dashboard/data/models/admin_user_model.dart';
import 'package:cicoattendance/features/admin_dashboard/domain/repository/i_user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepositoryImpl implements IUserRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<AdminUserModel>> getAllUsers() async {
    final snapshot = await _db.collection('users').get();

    return snapshot.docs
        .map((doc) => AdminUserModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}
