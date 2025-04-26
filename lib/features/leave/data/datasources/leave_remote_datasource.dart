/* step 3 */

import 'package:cicoattendance/features/leave/data/models/leave_request_model.dart';
import 'package:cicoattendance/features/leave/domain/entities/leave_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveRemoteDatasource {
  final FirebaseFirestore firestore;

  LeaveRemoteDatasource(this.firestore);

  CollectionReference get _collection => firestore.collection('leave_requests');

  Future<void> submitLeaveRequest(LeaveRequestEntity request) async {
    print('request.id: ${request.id}');
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

    // Step 1: Check if there is already a pending or approved leave for this user
    final existing = await _collection
        .where('userId', isEqualTo: request.userId)
        .where('startDate',
            isLessThanOrEqualTo: Timestamp.fromDate(request.endDate))
        .where('endDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(request.startDate))
        .where('status', whereIn: ['pending', 'approved'])
        .limit(1)
        .get();
    print('existing.docs.isNotEmpty: ${existing.docs.isNotEmpty}');

    if (existing.docs.isNotEmpty) {
      throw Exception('You already have a leave request for this period.');
    }

    if (model.id.isEmpty) {
      // 🔥 New request, let Firestore auto-generate ID
      print('id is empty');
      print('to map model: ${model.toMap()}');
      await _collection.add(model.toMap());
    } else {
      // 🔥 Existing request (e.g., admin update), use doc ID
      await _collection.doc(model.id).set(model.toMap());
    }

    // await _collection.doc(model.id).set(model.toMap());
  }

  Future<List<LeaveRequestEntity>> getLeaveRequestsForUser(String uid) async {
    final snapshot = await _collection.where('userId', isEqualTo: uid).get();

    return snapshot.docs
        .map((doc) => LeaveRequestModel.fromFirestore(doc))
        .toList();
  }

  Future<List<LeaveRequestEntity>> getAllLeaveRequests() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => LeaveRequestModel.fromFirestore(doc))
        .toList();
  }

  Future<void> updateLeaveStatus(String requestId, String status,
      {String? rejectedReason}) async {
    final data = {'status': status};
    print('rejectedReason: $rejectedReason');
    if (rejectedReason != null && rejectedReason.isNotEmpty) {
      data['rejectedReason'] = rejectedReason;
    }
    await _collection.doc(requestId).update(data);
  }
}
