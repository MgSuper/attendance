/* step 5 */

import 'package:cicoattendance/features/check_io/data/datasources/check_io_remote_datasource.dart';
import 'package:cicoattendance/features/check_io/domain/entities/check_io_config_entity.dart';
import 'package:cicoattendance/features/check_io/domain/repository_interface.dart';

class CheckIORepositoryImpl implements ICheckIORepository {
  final CheckIORemoteDatasource datasource;

  CheckIORepositoryImpl(this.datasource);

  @override
  Future<CheckIOConfigEntity> fetchCheckIOConfig() {
    return datasource.fetchCheckIOConfig();
  }
}
