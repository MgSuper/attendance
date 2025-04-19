import 'package:cicoattendance/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:cicoattendance/features/auth/data/repository_impl/repository_impl.dart';
import 'package:cicoattendance/features/auth/domain/repository_interface/repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
IAuthRepository authRepository(Ref ref) {
  final datasource = AuthRemoteDatasource(FirebaseAuth.instance);
  return AuthRepositoryImpl(datasource);
}
