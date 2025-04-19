import 'package:cicoattendance/features/auth/domain/entities/user_entity.dart';
import 'package:multiple_result/multiple_result.dart';

typedef AuthResult = Result<UserEntity, Exception>;

abstract class IAuthRepository {
  Future<AuthResult> signIn(String email, String password);
  Future<void> signOut();
}
