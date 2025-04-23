/* step 3 */

import 'package:cicoattendance/features/check_io/data/models/attendance_log_model.dart';
import 'package:cicoattendance/features/check_io/data/models/check_io_config_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckIORemoteDatasource {
  final FirebaseFirestore _firestore;

  CheckIORemoteDatasource(this._firestore);

  Future<CheckIOConfigModel> fetchCheckIOConfig() async {
    print('check id config');
    final doc = await _firestore.collection('config').doc('check_io').get();
    if (!doc.exists) throw Exception("CheckIO config not found");

    return CheckIOConfigModel.fromJson(doc.data()!);
  }

  /* Save Attendance Records step 2 */

  Future<void> saveAttendanceLog(AttendanceLogModel log) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('attendance_logs')
        .doc();

    await docRef.set(log.toJson());
  }
}
