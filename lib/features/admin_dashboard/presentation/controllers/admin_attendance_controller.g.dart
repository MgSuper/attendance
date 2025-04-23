// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_attendance_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAttendanceHash() => r'df0c973c234fe0a2f0ea3bd9bbbc6a8611bfd78f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UserAttendance
    extends BuildlessAutoDisposeAsyncNotifier<List<AdminAttendanceLogModel>> {
  late final String uid;
  late final DateTime selectedMonth;

  FutureOr<List<AdminAttendanceLogModel>> build(
    String uid,
    DateTime selectedMonth,
  );
}

/// See also [UserAttendance].
@ProviderFor(UserAttendance)
const userAttendanceProvider = UserAttendanceFamily();

/// See also [UserAttendance].
class UserAttendanceFamily
    extends Family<AsyncValue<List<AdminAttendanceLogModel>>> {
  /// See also [UserAttendance].
  const UserAttendanceFamily();

  /// See also [UserAttendance].
  UserAttendanceProvider call(
    String uid,
    DateTime selectedMonth,
  ) {
    return UserAttendanceProvider(
      uid,
      selectedMonth,
    );
  }

  @override
  UserAttendanceProvider getProviderOverride(
    covariant UserAttendanceProvider provider,
  ) {
    return call(
      provider.uid,
      provider.selectedMonth,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userAttendanceProvider';
}

/// See also [UserAttendance].
class UserAttendanceProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserAttendance, List<AdminAttendanceLogModel>> {
  /// See also [UserAttendance].
  UserAttendanceProvider(
    String uid,
    DateTime selectedMonth,
  ) : this._internal(
          () => UserAttendance()
            ..uid = uid
            ..selectedMonth = selectedMonth,
          from: userAttendanceProvider,
          name: r'userAttendanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAttendanceHash,
          dependencies: UserAttendanceFamily._dependencies,
          allTransitiveDependencies:
              UserAttendanceFamily._allTransitiveDependencies,
          uid: uid,
          selectedMonth: selectedMonth,
        );

  UserAttendanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.selectedMonth,
  }) : super.internal();

  final String uid;
  final DateTime selectedMonth;

  @override
  FutureOr<List<AdminAttendanceLogModel>> runNotifierBuild(
    covariant UserAttendance notifier,
  ) {
    return notifier.build(
      uid,
      selectedMonth,
    );
  }

  @override
  Override overrideWith(UserAttendance Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserAttendanceProvider._internal(
        () => create()
          ..uid = uid
          ..selectedMonth = selectedMonth,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        selectedMonth: selectedMonth,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UserAttendance,
      List<AdminAttendanceLogModel>> createElement() {
    return _UserAttendanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAttendanceProvider &&
        other.uid == uid &&
        other.selectedMonth == selectedMonth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, selectedMonth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserAttendanceRef
    on AutoDisposeAsyncNotifierProviderRef<List<AdminAttendanceLogModel>> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `selectedMonth` of this provider.
  DateTime get selectedMonth;
}

class _UserAttendanceProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserAttendance,
        List<AdminAttendanceLogModel>> with UserAttendanceRef {
  _UserAttendanceProviderElement(super.provider);

  @override
  String get uid => (origin as UserAttendanceProvider).uid;
  @override
  DateTime get selectedMonth =>
      (origin as UserAttendanceProvider).selectedMonth;
}

String _$selectedMonthHash() => r'591dddeda8569ba087bebd85adf1db57bb241330';

/// See also [SelectedMonth].
@ProviderFor(SelectedMonth)
final selectedMonthProvider =
    AutoDisposeNotifierProvider<SelectedMonth, DateTime>.internal(
  SelectedMonth.new,
  name: r'selectedMonthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedMonthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedMonth = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
