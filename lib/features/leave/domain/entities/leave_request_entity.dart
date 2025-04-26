/* domain layer step 1 */

class LeaveRequestEntity {
  final String id;
  final String userId;
  final String userName;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // pending, approved, rejected
  final DateTime requestedAt;
  final String? rejectedReason;

  LeaveRequestEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.rejectedReason,
  });
}
