import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';

class GetAllLeaveRequestsUseCase {
  final LeaveRepository repository;

  GetAllLeaveRequestsUseCase(this.repository);

  Future<List<LeaveRequestEntity>> call() {
    return repository.getAllLeaveRequests();
  }
}
