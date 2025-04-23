import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../check_io/data/models/attendance_log_model.dart';

part 'attendance_log_provider.g.dart';

@riverpod
Future<List<AttendanceLogModel>> attendanceLogs(Ref ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('attendance_logs')
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return AttendanceLogModel(
      type: data['type'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      distanceFromTarget: (data['distance_from_target'] as num).toDouble(),
      reason: data['reason'],
    );
  }).toList();
}
