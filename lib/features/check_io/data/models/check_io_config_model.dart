/* step 2 */

import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';

class CheckIOConfigModel extends CheckIOConfigEntity {
  const CheckIOConfigModel({
    required super.lat,
    required super.lng,
    required super.checkInStart,
    required super.checkOutStart,
  });

  factory CheckIOConfigModel.fromJson(Map<String, dynamic> json) {
    return CheckIOConfigModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      checkInStart: json['check_in_start'] as String,
      checkOutStart: json['check_out_start'] as String,
    );
  }
}
