/* step 7 */

import 'package:cicoattendance/features/check_io/data/datasources/check_io_remote_datasource.dart';
import 'package:cicoattendance/features/check_io/data/repository_impl.dart';
import 'package:cicoattendance/features/check_io/domain/repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_io_provider.g.dart';

@Riverpod(keepAlive: true)
ICheckIORepository checkIORepository(Ref ref) {
  final datasource = CheckIORemoteDatasource(FirebaseFirestore.instance);
  return CheckIORepositoryImpl(datasource);
}
