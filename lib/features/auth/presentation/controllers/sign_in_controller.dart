import 'package:cicoattendance/features/auth/domain/entities/user_entity.dart';
import 'package:cicoattendance/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:cicoattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:cicoattendance/router/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  FutureOr<UserEntity?> build() {
    return null; // or initial user if needed
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    final usecase = SignInUseCase(repository);
    final result = await usecase(email, password);

    result.when(
      (user) async {
        state = AsyncData(user);
        await ensureUserDocumentExists(); // no args

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

  Future<void> ensureUserDocumentExists() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'role': 'user', // ✅ default role
      });
    }
  }
}
