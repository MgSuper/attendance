/* step 8 */

import 'package:cicoattendance/features/check_io/data/datasources/check_io_remote_datasource.dart';
import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';
import 'package:cicoattendance/features/check_io/domain/usecases/fetch_check_io_config_usecase.dart';
import 'package:cicoattendance/features/check_io/domain/usecases/save_attendance_log_usecase.dart';
import 'package:cicoattendance/features/check_io/presentation/providers/check_io_provider.dart';
import 'package:cicoattendance/features/check_io/presentation/widgets/check_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_io_controller.g.dart';

@riverpod
class CheckIOController extends _$CheckIOController {
  @override
  FutureOr<CheckIOConfigEntity?> build() async {
    final repo = ref.read(checkIORepositoryProvider);
    return await FetchCheckIOConfigUseCase(repo).call();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      return await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best),
      );
    } on LocationServiceDisabledException {
      throw Exception("Location services are disabled.");
    } on Exception catch (e) {
      throw Exception("Failed to get location: $e");
    }
  }

  /// Returns distance in meters
  double calculateDistance({
    required double userLat,
    required double userLng,
    required double targetLat,
    required double targetLng,
  }) {
    return Geolocator.distanceBetween(userLat, userLng, targetLat, targetLng);
  }

  bool isWithinAllowedTime({
    required bool isCheckIn,
    required String requiredTime, // e.g. "08:30" or "17:00"
  }) {
    final now = DateTime.now();
    final [hour, minute] = requiredTime.split(':').map(int.parse).toList();
    final time = DateTime(now.year, now.month, now.day, hour, minute);
    return isCheckIn ? now.isAfter(time) : now.isAfter(time);
  }

  /* Save Attendance Records step 4 */

  Future<void> submitCheckIO({
    required String type, // 'check_in' or 'check_out'
    required double lat,
    required double lng,
    required double distance,
    String? reason, // ✅ optional reason for late check-in
  }) async {
    final ds = CheckIORemoteDatasource(FirebaseFirestore.instance);
    final usecase = SaveAttendanceLogUseCase(ds);

    await usecase(
      type: type,
      lat: lat,
      lng: lng,
      distance: distance,
      reason: reason, // ✅ forward reason to use case
    );
  }

  Future<bool> hasAlreadyChecked(String type) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('attendance_logs')
        .where('type', isEqualTo: type)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<TodayStatus> getTodayStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return TodayStatus.none;

    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final logs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('attendance_logs')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('timestamp', isLessThan: Timestamp.fromDate(todayEnd))
        .get();

    final types = logs.docs.map((doc) => doc.data()['type']).toList();

    if (types.contains('check_out')) return TodayStatus.checkedOut;
    if (types.contains('check_in')) return TodayStatus.checkedIn;
    return TodayStatus.none;
  }
}
