import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/legacy.dart';



// ============================================================
// THEME NOTIFIER
// ============================================================

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);


  void toggleTheme() {
    state = state == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }
}

final themeNotifierProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

// ============================================================
// FLYLORS LIGHT
// ============================================================

class Flylorslight {
  // Base
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  // Accent
  static const accent = Color(0xFFF2A65A);
  static const accent1 = Color(0xFFD98B3A);
  static const accent2 = Color(0xFFE6B85C);
  static const accent3 = Color(0xFFF5E6B3);

  // Primary
  static const primary1 = Color(0xFF143601);
  static const primary2 = Color(0xFF1A4301);
  static const primary3 = Color(0xFF245501);
  static const primary4 = Color(0xFF538D22);
  static const primary5 = Color(0xFF73A942);
  static const primary6 = Color(0xFFAAD576);
  static const primary7 = Color(0xFFC5E5A0);

  // UI
  static const border = Color(0xFFDCE8CE);
  static const divider = Color(0xFFE8EFDF);
  static const overlay = Color(0x80000000);

  static const background = Color(0xFFF5F8EF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFEDF4E5);

  // Text
  static const textPrimary = Color(0xFF143601);
  static const textSecondary = Color(0xFF538D22);
  static const textDisabled = Color(0xFFA0AD94);
}

// ============================================================
// FLYLORS DARK
// ============================================================

class Flylorsdark {
  // Base
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  // Accent
  static const accent = Color(0xFFF2A65A);
  static const accent1 = Color(0xFFD98B3A);
  static const accent2 = Color(0xFFE6B85C);
  static const accent3 = Color(0xFFF5E6B3);

  // Primary
  static const primary1 = Color(0xFF0A1C05);
  static const primary2 = Color(0xFF102B06);
  static const primary3 = Color(0xFF193B0A);
  static const primary4 = Color(0xFF2D5718);
  static const primary5 = Color(0xFF538D22);
  static const primary6 = Color(0xFF73A942);
  static const primary7 = Color(0xFFAAD576);

  // UI
  static const border = Color(0xFF2D4025);
  static const divider = Color(0xFF24351D);
  static const overlay = Color(0x80000000);

  static const background = Color(0xFF0D160A);
  static const surface = Color(0xFF152110);
  static const surfaceVariant = Color(0xFF1D2D17);

  // Text
  static const textPrimary = Color(0xFFF1F5EB);
  static const textSecondary = Color(0xFFAAD576);
  static const textDisabled = Color(0xFF718267);
}

// ============================================================
// FLYLORS THEME
// ============================================================

class FlylorsTheme {
  static final ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,

    scaffoldBackgroundColor: Flylorslight.background,

    colorScheme: const ColorScheme.light(
      primary: Flylorslight.primary2,
      secondary: Flylorslight.accent,
      surface: Flylorslight.surface,
      error: Color(0xFFD32F2F),
      onPrimary: Flylorslight.white,
      onSecondary: Flylorslight.black,
      onSurface: Flylorslight.textPrimary,
    ),

    dividerColor: Flylorslight.divider,

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Flylorslight.surfaceVariant,
      hintStyle: TextStyle(
        fontSize: 18,
        color: Flylorslight.textSecondary,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(20),
        foregroundColor: Flylorslight.primary3,
      ),
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: Flylorsdark.background,

    colorScheme: const ColorScheme.dark(
      primary: Flylorsdark.primary5,
      secondary: Flylorsdark.accent,
      surface: Flylorsdark.surface,
      error: Color(0xFFEF5350),
      onPrimary: Flylorsdark.white,
      onSecondary: Flylorsdark.black,
      onSurface: Flylorsdark.textPrimary,
    ),

    dividerColor: Flylorsdark.divider,

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Flylorsdark.surfaceVariant,
      hintStyle: TextStyle(
        fontSize: 18,
        color: Flylorsdark.textSecondary,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(20),
        foregroundColor: Flylorsdark.primary7,
      ),
    ),
  );
}
