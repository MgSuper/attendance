/* p step 4 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cicoattendance/features/profile/data/models/user_model.dart';
import 'package:cicoattendance/features/profile/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/profile/domain/repository/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final FirebaseFirestore firestore;

  ProfileRepositoryImpl(this.firestore);

  @override
  Future<UserEntity> getUserProfile(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception("User profile not found");
    }

    final data = doc.data()!;
    final model = UserModel.fromJson(data, uid);
    return model.toEntity();
  }
}
