import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAttendanceLogModel {
  final String type; // check_in / check_out
  final Timestamp timestamp;
  final double? distance;
  final String? reason;

  AdminAttendanceLogModel({
    required this.type,
    required this.timestamp,
    this.distance,
    this.reason,
  });

  factory AdminAttendanceLogModel.fromJson(Map<String, dynamic> json) {
    return AdminAttendanceLogModel(
      type: json['type'],
      timestamp: json['timestamp'],
      distance: (json['distance'] as num?)?.toDouble(),
      reason: json['reason'],
    );
  }
}
