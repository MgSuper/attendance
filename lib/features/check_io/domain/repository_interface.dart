/* step 4 */

import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';

abstract class ICheckIORepository {
  Future<CheckIOConfigEntity> fetchCheckIOConfig();
}
