import 'package:cicoattendance/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:cicoattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:cicoattendance/router/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    final usecase = SignInUseCase(repository);
    final result = await usecase(email, password);

    result.when(
      (user) {
        state = AsyncData(user);
        ref.read(goRouterProvider).go('/home'); // ✅ Navigate to home
      },
      (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
    ref.read(goRouterProvider).go('/sign-in'); // 👈 back to sign-in
  }
}
