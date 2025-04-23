import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';
import 'package:cicoattendance/features/check_io/presentation/controllers/check_io_controller.dart';
import 'package:cicoattendance/features/check_io/presentation/providers/holidays_provider.dart';
import 'package:cicoattendance/features/check_io/presentation/widgets/check_buttons.dart';
import 'package:cicoattendance/features/check_io/presentation/widgets/check_io_shimmer_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class CheckIOScreen extends HookConsumerWidget {
  const CheckIOScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(checkIOControllerProvider);
    final controller = ref.read(checkIOControllerProvider.notifier);

    final holidaysAsync = ref.watch(uHolidayDatesProvider);

    final location = useState<String>('Detecting...');
    final distance = useState<double?>(null);
    final isWithinRange = useState(false);
    final currentPosition = useState<Position?>(null);
    final hasFetchedLocation = useState(false);

    useEffect(() {
      if (configAsync is AsyncData && !hasFetchedLocation.value) {
        Future.microtask(() async {
          try {
            final pos = await controller.getCurrentLocation();
            if (pos != null) {
              final config = configAsync.value!;
              final dist = controller.calculateDistance(
                userLat: pos.latitude,
                userLng: pos.longitude,
                targetLat: config.lat,
                targetLng: config.lng,
              );

              currentPosition.value = pos;
              location.value =
                  '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
              distance.value = dist;
              isWithinRange.value = dist <= 10;
              hasFetchedLocation.value = true;
            } else {
              location.value = 'Permission Denied';
              distance.value = null;
              isWithinRange.value = false;
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("❌ Failed to detect location."),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    hasFetchedLocation.value = false;
                  },
                ),
              ),
            );
          }
        });
      }
      return null;
    }, [configAsync]);

    return configAsync.when(
      loading: () => const CheckIOShimmerPlaceholder(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (config) {
        return holidaysAsync.when(
          loading: () => const CheckIOShimmerPlaceholder(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (holidays) {
            final today = DateTime.now();
            final todayStr =
                "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

            final isWeekend = today.weekday == DateTime.saturday ||
                today.weekday == DateTime.sunday;
            final holidayName = holidays[todayStr];
            final isHoliday = holidayName != null;

            if (isWeekend || isHoliday) {
              return Center(
                child: Text(
                  isHoliday
                      ? "🎉 $holidayName\nWe don't work on holidays."
                      : "🎉 It's the weekend!\nWe don't work on Saturdays or Sundays.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Check-In / Check-Out",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Your location: ${location.value}')),
                    ],
                  ),
                  if (distance.value != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          'Distance: ${distance.value!.toStringAsFixed(2)} meters'),
                    ),
                  const SizedBox(height: 16),
                  if (!isWithinRange.value && hasFetchedLocation.value)
                    const Text("❌ You are not within range (≤ 10m)",
                        style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  if (isWithinRange.value && currentPosition.value != null)
                    CheckButtons(
                      config: config!,
                      controller: controller,
                      pos: currentPosition.value!,
                      distance: distance.value!,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
