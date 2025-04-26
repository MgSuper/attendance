/* step 5 */

import 'package:cicoattendance/features/leave/data/datasources/leave_remote_datasource.dart';
import 'package:cicoattendance/features/leave/data/models/leave_request_model.dart';
import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cicoattendance/features/leave/domain/repository_interface/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDatasource remoteDatasource;

  LeaveRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> submitLeaveRequest(LeaveRequestEntity request) async {
    final model = LeaveRequestModel(
      id: request.id,
      userId: request.userId,
      userName: request.userName,
      startDate: request.startDate,
      endDate: request.endDate,
      reason: request.reason,
      status: request.status,
      requestedAt: request.requestedAt,
    );
    await remoteDatasource.submitLeaveRequest(model);
  }

  @override
  Future<List<LeaveRequestEntity>> getLeaveRequestsForUser(String uid) async {
    return await remoteDatasource.getLeaveRequestsForUser(uid);
  }

  @override
  Future<List<LeaveRequestEntity>> getAllLeaveRequests() async {
    return await remoteDatasource.getAllLeaveRequests();
  }

  @override
  Future<void> updateLeaveStatus(String requestId, String status,
      {String? rejectedReason}) async {
    // print('rejectedReason 3 : $rejectedReason');
    await remoteDatasource.updateLeaveStatus(requestId, status,
        rejectedReason: rejectedReason);
  }
}
