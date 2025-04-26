/* step 6 */

import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';

class SubmitLeaveRequestUseCase {
  final LeaveRepository repository;

  SubmitLeaveRequestUseCase(this.repository);

  Future<void> call(LeaveRequestEntity request) {
    return repository.submitLeaveRequest(request);
  }
}
