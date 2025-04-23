import 'package:cicoattendance/common/widgets/shimmer/shimmer_container.dart';
import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';
import 'package:cicoattendance/features/check_io/presentation/controllers/check_io_controller.dart';
import 'package:cicoattendance/features/check_io/presentation/widgets/late_reason_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TodayStatus { none, checkedIn, checkedOut }

class CheckButtons extends HookConsumerWidget {
  final CheckIOConfigEntity config;
  final CheckIOController controller;
  final Position pos;
  final double distance;

  const CheckButtons({
    super.key,
    required this.config,
    required this.controller,
    required this.pos,
    required this.distance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lateReason = useState<String?>(null);
    final reasonSubmitted = useState(false);
    final now = DateTime.now();

    // Time windows
    final checkInStart = DateTime(now.year, now.month, now.day, 8, 30);
    final checkInEnd = DateTime(now.year, now.month, now.day, 17, 0);
    final lateThreshold = DateTime(now.year, now.month, now.day, 9, 0);
    final checkOutStart = DateTime(now.year, now.month, now.day, 17, 0);
    final checkOutEnd = DateTime(now.year, now.month, now.day + 1, 8, 30);

    final inCheckInTime = now.isAfter(checkInStart) && now.isBefore(checkInEnd);

    print('now.isAfter(checkOutStart): ${now.isAfter(checkOutStart)}');
    final inCheckOutTime =
        now.isAfter(checkOutStart) && now.isBefore(checkOutEnd);
    final isLate = now.isAfter(lateThreshold);

    // Load Firestore state
    final statusAsync = useMemoized(() => controller.getTodayStatus());
    final statusSnapshot = useFuture(statusAsync);

    if (statusSnapshot.connectionState != ConnectionState.done) {
      return ShimmerContainer(width: double.infinity, height: 48);
    }

    final status = statusSnapshot.data ?? TodayStatus.none;

    print('status status >>>>> $status');
    print('inCheckOutTime >>>>> ${!inCheckOutTime}');
    print(
        'status == TodayStatus.checkedIn && !inCheckOutTime >>>> ${status == TodayStatus.checkedIn && !inCheckOutTime}');

    print('now: $now');
    print('checkOutStart: $checkOutStart');
    print('inCheckOutTime: $inCheckOutTime');
    print('status: $status');

    // ✅ Already checked out today
    if (status == TodayStatus.checkedOut) {
      return const Text("✅ You've already checked out today.");
    }

    // ✅ Eligible for check-out
    if (status == TodayStatus.checkedIn && inCheckOutTime) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          try {
            await controller.submitCheckIO(
              type: 'check_out',
              lat: pos.latitude,
              lng: pos.longitude,
              distance: distance,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Check-out recorded")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("❌ Check-out failed."),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    ref.refresh(checkIOControllerProvider);
                  },
                ),
              ),
            );
          }
        },
        child: const Text("Check Out"),
      );
    }

    // ⏳ Checked in but too early to check out
    if (status == TodayStatus.checkedIn && !inCheckOutTime) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("⏳ Wait until 5:00 PM to check out"),
      );
    }

    // ✅ Eligible for check-in
    if (status == TodayStatus.none && inCheckInTime) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          try {
            if (isLate) {
              final reason = await showLateReasonDialog(context);
              if (reason == null || reason.isEmpty) return;
              lateReason.value = reason;
              reasonSubmitted.value = true;
            } else {
              reasonSubmitted.value = true;
            }

            await controller.submitCheckIO(
              type: 'check_in',
              lat: pos.latitude,
              lng: pos.longitude,
              distance: distance,
              reason: lateReason.value,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Check-in recorded")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("❌ Check-in failed."),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    ref.refresh(checkIOControllerProvider);
                  },
                ),
              ),
            );
          }
        },
        child: const Text("Check In"),
      );
    }

    return const Text("🕗 You can check in from 08:30 to 16:59");
  }
}
