import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

enum AppThemeMode { light, dark, black }

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  AppThemeMode build() {
    _loadFromPrefs();
    return AppThemeMode.light; // default
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('theme_mode') ?? 'light';
    final loaded = AppThemeMode.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemeMode.light,
    );
    state = loaded;
  }

  Future<void> _saveToPrefs(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }

  void cycle() {
    final nextIndex = (state.index + 1) % AppThemeMode.values.length;
    final nextMode = AppThemeMode.values[nextIndex];
    state = nextMode;
    _saveToPrefs(nextMode);
  }

  void set(AppThemeMode mode) {
    state = mode;
    _saveToPrefs(mode);
  }
}
