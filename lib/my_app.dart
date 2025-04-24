import 'package:cicoattendance/core/theme/app_theme.dart';
import 'package:cicoattendance/core/theme/theme_provider.dart';
import 'package:cicoattendance/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final appThemeMode = ref.watch(themeModeNotifierProvider);

    // Choose correct base theme mode
    final baseThemeMode =
        appThemeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark;

    // Select black theme override if needed
    final useBlackTheme = appThemeMode == AppThemeMode.black;
    final overrideTheme = useBlackTheme ? AppTheme.black : null;

    return TweenAnimationBuilder<ThemeData>(
      tween: ThemeDataTween(
        end: overrideTheme ??
            (appThemeMode == AppThemeMode.light
                ? AppTheme.light
                : AppTheme.dark),
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, animatedTheme, _) {
        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: baseThemeMode,
          builder: (context, child) {
            return Theme(data: animatedTheme, child: child!);
          },
        );
      },
    );
  }
}
