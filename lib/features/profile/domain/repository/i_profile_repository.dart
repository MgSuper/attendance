/* p step 3 */

import 'package:cicoattendance/features/profile/domain/entities/user_entity.dart';

abstract class IProfileRepository {
  Future<UserEntity> getUserProfile(String uid);
}
