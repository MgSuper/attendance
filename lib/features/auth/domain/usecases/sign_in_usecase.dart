import 'package:cicoattendance/features/auth/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/auth/domain/repository_interface/repository_interface.dart';
import 'package:multiple_result/multiple_result.dart';

class SignInUseCase {
  final IAuthRepository repository;

  SignInUseCase(this.repository);

  Future<Result<UserEntity, Exception>> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
