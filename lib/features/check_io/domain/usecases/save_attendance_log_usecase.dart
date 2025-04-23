import 'package:cicoattendance/features/check_io/data/datasources/check_io_remote_datasource.dart';
import 'package:cicoattendance/features/check_io/data/models/attendance_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Save Attendance Records step 3 */
class SaveAttendanceLogUseCase {
  final CheckIORemoteDatasource datasource;

  SaveAttendanceLogUseCase(this.datasource);

  Future<void> call({
    required String type, // 'check_in' or 'check_out'
    required double lat,
    required double lng,
    required double distance,
    String? reason, // ✅ new
  }) {
    final log = AttendanceLogModel(
      type: type,
      timestamp: Timestamp.now(),
      lat: lat,
      lng: lng,
      distanceFromTarget: distance,
      reason: reason, // ✅ pass to model
    );

    return datasource.saveAttendanceLog(log);
  }
}
