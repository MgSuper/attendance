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
    final inCheckOutTime =
        now.isAfter(checkOutStart) && now.isBefore(checkOutEnd);
    final isLate = now.isAfter(lateThreshold);

    // ✅ Watch status reactively
    final statusAsync = ref.watch(todayStatusNotifierProvider);

    return statusAsync.when(
      loading: () => const ShimmerContainer(width: double.infinity, height: 48),
      error: (e, _) => Text('❌ Error: $e'),
      data: (status) {
        if (status == TodayStatus.checkedOut) {
          return const Text('✅ You\'ve already checked out today.');
        }

        if (status == TodayStatus.checkedIn && inCheckOutTime) {
          return ElevatedButton(
            onPressed: () async {
              try {
                await controller.submitCheckIO(
                  type: 'check_out',
                  lat: pos.latitude,
                  lng: pos.longitude,
                  distance: distance,
                );
                await ref.read(todayStatusNotifierProvider.notifier).refresh();

                if (!context.mounted) return; // ✅ safe check

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Check-out recorded')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Check-out failed: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Check Out'),
          );
        }

        if (status == TodayStatus.checkedIn && !inCheckOutTime) {
          return ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('⏳ Wait until 5:00 PM to check out'),
          );
        }

        if (status == TodayStatus.none && inCheckInTime) {
          return ElevatedButton(
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
                await ref.read(todayStatusNotifierProvider.notifier).refresh();
                if (!context.mounted) return; // ✅ safe check
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Check-in recorded')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Check-in failed: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Check In'),
          );
        }

        return const Text('🕗 You can check in from 08:30 to 16:59');
      },
    );
  }
}
