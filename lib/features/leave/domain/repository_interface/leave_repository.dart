import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';

/* data layer step 4 */

abstract class LeaveRepository {
  Future<void> submitLeaveRequest(LeaveRequestEntity request);
  Future<List<LeaveRequestEntity>> getLeaveRequestsForUser(String uid);
  Future<List<LeaveRequestEntity>> getAllLeaveRequests(); // Admin
  Future<void> updateLeaveStatus(String requestId, String status,
      {String? rejectedReason});
}
