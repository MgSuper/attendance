import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';

class GetUserLeaveRequestsUseCase {
  final LeaveRepository repository;

  GetUserLeaveRequestsUseCase(this.repository);

  Future<List<LeaveRequestEntity>> call(String uid) {
    return repository.getLeaveRequestsForUser(uid);
  }
}
