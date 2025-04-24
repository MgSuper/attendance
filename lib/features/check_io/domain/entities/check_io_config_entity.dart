/* step 1 */
class CheckIOConfigEntity {
  final double lat;
  final double lng;
  final String checkInStart; // '08:30'
  final String checkOutStart; // '17:00'

  const CheckIOConfigEntity({
    required this.lat,
    required this.lng,
    required this.checkInStart,
    required this.checkOutStart,
  });
}
