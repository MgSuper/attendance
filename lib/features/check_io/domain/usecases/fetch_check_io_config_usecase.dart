/* step 6 */

import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';
import 'package:cicoattendance/features/check_io/domain/repository_interface.dart';

class FetchCheckIOConfigUseCase {
  final ICheckIORepository repository;

  FetchCheckIOConfigUseCase(this.repository);

  Future<CheckIOConfigEntity> call() {
    return repository.fetchCheckIOConfig();
  }
}
