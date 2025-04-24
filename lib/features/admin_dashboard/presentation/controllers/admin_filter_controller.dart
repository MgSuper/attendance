import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_filter_controller.g.dart';

@riverpod
class AdminFilterController extends _$AdminFilterController {
  @override
  (DateTime? selectedDate, String? userId) build() {
    return (null, null);
  }

  void setDate(DateTime? date) {
    state = (date, state.$2);
  }

  void setUserId(String? id) {
    state = (state.$1, id?.trim().isEmpty == true ? null : id);
  }
}
