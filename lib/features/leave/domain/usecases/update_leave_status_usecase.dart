import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';

class UpdateLeaveStatusUseCase {
  final LeaveRepository repository;

  UpdateLeaveStatusUseCase(this.repository);

  Future<void> call(String requestId, String status, {String? rejectedReason}) {
    print('rejectedReason 2 : $rejectedReason');
    return repository.updateLeaveStatus(requestId, status,
        rejectedReason: rejectedReason);
  }
}
