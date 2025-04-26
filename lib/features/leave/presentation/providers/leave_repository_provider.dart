/* step 7 */

import 'package:cicoattendance/features/leave/data/datasources/leave_remote_datasource.dart';
import 'package:cicoattendance/features/leave/data/repository_impl/leave_repository_impl.dart';
import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_repository_provider.g.dart';

@riverpod
LeaveRepository leaveRepository(Ref ref) {
  final datasource = LeaveRemoteDatasource(FirebaseFirestore.instance);
  return LeaveRepositoryImpl(datasource);
}
