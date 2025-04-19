import 'package:cicoattendance/features/auth/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/auth/domain/repository_interface/repository_interface.dart';
import 'package:cicoattendance/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SignInUseCase(mockRepository);
  });

  test('should return UserEntity on successful sign in', () async {
    const email = 'test@example.com';
    const password = 'password';
    const user = UserEntity(uid: '123', email: email);

    when(() => mockRepository.signIn(email, password)).thenAnswer(
      (_) async => const Success(user),
    );

    final result = await useCase(email, password);

    expect(result.isSuccess(), isTrue);
    expect(result.tryGetSuccess(), equals(user));
  });

  test('should return Error on failed sign in', () async {
    const email = 'wrong@example.com';
    const password = 'password';
    final exception = Exception('Login failed');

    when(() => mockRepository.signIn(email, password)).thenAnswer(
      (_) async => Error(exception),
    );

    final result = await useCase(email, password);

    expect(result.isError(), isTrue);
    expect(result.tryGetError(), equals(exception));
  });
}
