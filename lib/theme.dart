import 'package:material_ui/material_ui.dart';


// wiesz bo To nie colors tylko fireflycolors hehe flylors firelors colofly KUR*A MAC PO PROSTU NIE MOZE BYC FCOLORS
// class Flylorsbackup {
//   static const black = Color(0xff000000);
//   static const accent = Color(0xffF2A65A)
//   static const accent1 = Color(0xffB98235);
//   static const accent2 = Color(0xffE6B85C);
//   static const accent3 = Color(0xffF5E6B3);
//   static const primary1 = Color(0xff03045E);
//   static const primary2 = Color(0xff023E8A);
//   static const primary3 = Color(0xff0077B6);
//   static const primary4 = Color(0xff0096C7);
//   static const primary5 = Color(0xff00B4D8);
//   static const primary6 = Color(0xff48CAE4);
//   static const primary7 = Color(0xff90E0EF);
//   static const primary8 = Color(0xffADE8F4);
//   static const primary9 = Color(0xffCAF0F8);
//   static const white = Color(0xffe0f7ff);
// } gdybym potrzebowal to sa inne kolory

class Flylorslight {
  static const black = Color(0xff000000);
  static const white = Color(0xffFFFFFF);
  static const accent = Color(0xffF2A65A);
  static const accent1 = Color(0xffD98B3A);
  static const accent2 = Color(0xffE6B85C);
  static const accent3 = Color(0xffF5E6B3);
  static const primary1 = Color(0xff143601);
  static const primary2 = Color(0xff1A4301);
  static const primary3 = Color(0xff245501);
  static const primary4 = Color(0xff538D22);
  static const primary5 = Color(0xff73A942);
  static const primary6 = Color(0xffAAD576);
  static const primary7 = Color(0xffC5E5A0);

  // UI
  static const border = Color(0xffDCE8CE);
  static const divider = Color(0xffE8EFDF);
  static const overlay = Color(0x80000000);
  static const background = Color(0xffF5F8EF);
  static const surface = Color(0xffFFFFFF);
  static const surfaceVariant = Color(0xffEDF4E5);
  // Tekst
  static const textPrimary = Color(0xff143601);
  static const textSecondary = Color(0xff538D22);
  static const textDisabled = Color(0xffA0AD94);
}


class Flylorsdark {
  static const black = Color(0xff000000);
  static const white = Color(0xffFFFFFF);
  static const accent = Color(0xffF2A65A);
  static const accent1 = Color(0xffD98B3A);
  static const accent2 = Color(0xffE6B85C);
  static const accent3 = Color(0xffF5E6B3);
  static const primary1 = Color(0xff0A1C05);
  static const primary2 = Color(0xff102B06);
  static const primary3 = Color(0xff193B0A);
  static const primary4 = Color(0xff2D5718);
  static const primary5 = Color(0xff538D22);
  static const primary6 = Color(0xff73A942);
  static const primary7 = Color(0xffAAD576);
  // UI
  static const border = Color(0xff2D4025);
  static const divider = Color(0xff24351D);
  static const overlay = Color(0x80000000);
  static const background = Color(0xff0D160A);
  static const surface = Color(0xff152110);
  static const surfaceVariant = Color(0xff1D2D17);
  // Tekst
  static const textPrimary = Color(0xffF1F5EB);
  static const textSecondary = Color(0xffAAD576);
  static const textDisabled = Color(0xff718267);
}


class FlylorsTheme {
  static ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,

    scaffoldBackgroundColor: Flylorslight.background,

    colorScheme: const ColorScheme.light(
      primary: Flylorslight.primary2,
      secondary: Flylorslight.accent,
      surface: Flylorslight.surface,
      error: Color(0xffD32F2F),
      onPrimary: Flylorslight.white,
      onSecondary: Flylorslight.black,
      onSurface: Flylorslight.textPrimary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Flylorslight.surfaceVariant,
      hintStyle: const TextStyle(
        fontSize: 18,
        color: Flylorslight.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(
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

  static ThemeData dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: Flylorsdark.background,

    colorScheme: const ColorScheme.dark(
      primary: Flylorsdark.primary5,
      secondary: Flylorsdark.accent,
      surface: Flylorsdark.surface,
      error: Color(0xffEF5350),
      onPrimary: Flylorsdark.white,
      onSecondary: Flylorsdark.black,
      onSurface: Flylorsdark.textPrimary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Flylorsdark.surfaceVariant,
      hintStyle: const TextStyle(
        fontSize: 18,
        color: Flylorsdark.textSecondary,
      ),
      contentPadding: const EdgeInsets.symmetric(
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
