// leave_request_controller.dart
import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/presentation/providers/leave_usecases_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_request_controller.g.dart';

@riverpod
class LeaveRequestController extends _$LeaveRequestController {
  @override
  Future<List<LeaveRequestEntity>> build() async {
    final usecase = ref.read(getAllLeaveRequestsUseCaseProvider);
    return usecase();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final data = await ref.read(getAllLeaveRequestsUseCaseProvider)();
    state = AsyncData(data);
  }

  // ✅ UPDATED: Simplified and safer
  Future<bool> submitLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final request = LeaveRequestEntity(
        id: '',
        userId: user.uid,
        userName: user.email ?? 'Unknown',
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        status: 'pending',
        requestedAt: DateTime.now(),
      );

      final usecase = ref.read(submitLeaveRequestUseCaseProvider);
      await usecase(request);
      await refresh();
      return true; // ✅ success
    } catch (e) {
      print('here: $e');
      print('error in submitLeave: $e');
      return false; // ❌ failure
    }
  }

  Future<void> updateStatus(String requestId, String status,
      {String? rejectedReason}) async {
    print('rejectedReason 1 : $rejectedReason');
    final usecase = ref.read(updateLeaveStatusUseCaseProvider);
    await usecase(requestId, status, rejectedReason: rejectedReason);
    await refresh();
  }

  Future<List<LeaveRequestEntity>> getUserRequests(String uid) async {
    final usecase = ref.read(getUserLeaveRequestsUseCaseProvider);
    return await usecase(uid);
  }
}
