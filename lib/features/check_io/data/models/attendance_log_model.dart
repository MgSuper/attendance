import 'package:cloud_firestore/cloud_firestore.dart';

/* Save Attendance Records step 1 */

class AttendanceLogModel {
  final String type; // 'check_in' or 'check_out'
  final Timestamp timestamp;
  final double lat;
  final double lng;
  final double distanceFromTarget;
  final String? reason; // ✅ NEW FIELD

  AttendanceLogModel({
    required this.type,
    required this.timestamp,
    required this.lat,
    required this.lng,
    required this.distanceFromTarget,
    this.reason, // ✅ optional
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp,
      'lat': lat,
      'lng': lng,
      'distance_from_target': distanceFromTarget,
      if (reason != null) 'reason': reason, // ✅ optional field
    };
  }
}
