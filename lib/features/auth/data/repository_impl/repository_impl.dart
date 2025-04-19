import 'package:cicoattendance/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:cicoattendance/features/auth/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/auth/domain/repository_interface/repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Result<UserEntity, Exception>> signIn(
      String email, String password) async {
    try {
      final user = await datasource.signIn(email, password);
      return Success(UserEntity(uid: user.uid, email: user.email ?? ''));
    } catch (e) {
      return Error(Exception('Sign in failed'));
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
