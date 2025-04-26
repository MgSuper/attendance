/* data layer step 2 */

import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRequestModel extends LeaveRequestEntity {
  LeaveRequestModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.startDate,
    required super.endDate,
    required super.reason,
    required super.status,
    required super.requestedAt,
    super.rejectedReason,
  });

  factory LeaveRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaveRequestModel(
      id: doc.id,
      userId: data['userId'],
      userName: data['userName'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      reason: data['reason'],
      status: data['status'],
      requestedAt: (data['requestedAt'] as Timestamp).toDate(),
      rejectedReason: data['rejectedReason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'reason': reason,
      'status': status,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'rejectedReason': rejectedReason,
    };
  }

  factory LeaveRequestModel.fromEntity(LeaveRequestEntity entity) {
    return LeaveRequestModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      startDate: entity.startDate,
      endDate: entity.endDate,
      reason: entity.reason,
      status: entity.status,
      requestedAt: entity.requestedAt,
      rejectedReason: entity.rejectedReason,
    );
  }
}
