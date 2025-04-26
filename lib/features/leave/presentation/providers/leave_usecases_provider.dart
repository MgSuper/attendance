/* step 8 */

import 'package:cicoattendance/features/leave/domain/usecases/fetch_leave_requests_usecase.dart';
import 'package:cicoattendance/features/leave/domain/usecases/get_user_leave_requests_usecase.dart';
import 'package:cicoattendance/features/leave/domain/usecases/submit_leave_request_usecase.dart';
import 'package:cicoattendance/features/leave/domain/usecases/update_leave_status_usecase.dart';
import 'package:cicoattendance/features/leave/presentation/providers/leave_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_usecases_provider.g.dart';

@riverpod
SubmitLeaveRequestUseCase submitLeaveRequestUseCase(Ref ref) {
  return SubmitLeaveRequestUseCase(ref.watch(leaveRepositoryProvider));
}

@riverpod
GetUserLeaveRequestsUseCase getUserLeaveRequestsUseCase(Ref ref) {
  return GetUserLeaveRequestsUseCase(ref.watch(leaveRepositoryProvider));
}

@riverpod
GetAllLeaveRequestsUseCase getAllLeaveRequestsUseCase(Ref ref) {
  return GetAllLeaveRequestsUseCase(ref.watch(leaveRepositoryProvider));
}

@riverpod
UpdateLeaveStatusUseCase updateLeaveStatusUseCase(Ref ref) {
  return UpdateLeaveStatusUseCase(ref.watch(leaveRepositoryProvider));
}
