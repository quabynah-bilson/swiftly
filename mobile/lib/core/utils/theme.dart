import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_utils/shared_utils.dart';

extension ThemeBuilderX on BuildContext {
  ThemeData get useLightTheme {
    const disabledColor = Color(0xffA1A5AB);
    final colorScheme = useColorScheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.background,
      disabledColor: disabledColor,
      colorScheme: colorScheme,
      platform: TargetPlatform.iOS,
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.background,
        selectedTileColor: colorScheme.surface,
        selectedColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
      iconTheme: IconThemeData(color: colorScheme.onBackground, fill: 0.85),
      buttonTheme: ButtonThemeData(
          colorScheme: colorScheme,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
      dividerTheme: DividerThemeData(
          color: colorScheme.surfaceVariant,
          indent: 20,
          endIndent: 20,
          space: 16),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.background,
          elevation: 0,
          scrolledUnderElevation: 0),
      textTheme: _textTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        prefixIconColor: colorScheme.onSurface.withOpacity(kEmphasisMedium),
        hintStyle:
            TextStyle(color: colorScheme.onSurface.withOpacity(kEmphasisLow)),
        labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(kEmphasisMedium)),
        suffixIconColor: colorScheme.onSurface.withOpacity(kEmphasisMedium),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.surface),
            borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.surface),
            borderRadius: BorderRadius.circular(40)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.secondary),
            borderRadius: BorderRadius.circular(40)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
            borderRadius: BorderRadius.circular(40)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
            borderRadius: BorderRadius.circular(40)),
      ),
    );
  }

  ThemeData get useDarkTheme {
    final colorScheme = useColorScheme(ThemeMode.dark);
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      colorScheme: colorScheme,
      platform: TargetPlatform.iOS,
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.background,
        selectedTileColor: colorScheme.surface,
        selectedColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
      textTheme: _textTheme(Colors.white),
      scaffoldBackgroundColor: colorScheme.background,
      iconTheme: IconThemeData(color: colorScheme.onBackground, fill: 0.85),
      buttonTheme: ButtonThemeData(
          colorScheme: colorScheme,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
      dividerTheme: DividerThemeData(
          color: colorScheme.onBackground.withOpacity(kEmphasisLowest),
          indent: 20,
          endIndent: 20,
          space: 16),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.background,
          elevation: 0,
          scrolledUnderElevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        prefixIconColor: colorScheme.onSurface.withOpacity(kEmphasisMedium),
        hintStyle:
            TextStyle(color: colorScheme.onSurface.withOpacity(kEmphasisLow)),
        labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(kEmphasisMedium)),
        suffixIconColor: colorScheme.onSurface.withOpacity(kEmphasisMedium),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.surface),
            borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.surface),
            borderRadius: BorderRadius.circular(40)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.secondary),
            borderRadius: BorderRadius.circular(40)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
            borderRadius: BorderRadius.circular(40)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
            borderRadius: BorderRadius.circular(40)),
      ),
    );
  }
}

/// setup color scheme
ColorScheme useColorScheme([ThemeMode mode = ThemeMode.light]) =>
    mode == ThemeMode.light
        ? ColorScheme.light(
            background: Colors.white,
            onBackground: Colors.black,
            secondary: const Color(0xff17134F),
            onSecondary: Colors.white,
            secondaryContainer: const Color(0xff17134F),
            onSecondaryContainer: Colors.white,
            primary: const Color(0xff17134F),
            onPrimary: Colors.white,
            surface: const Color(0xffF2F3F5),
            onSurface: Colors.black,
            surfaceVariant: const Color(0xffE4E5E9),
            onSurfaceVariant: Colors.black,
            outline: const Color(0xffEBEDEE),
            outlineVariant: Colors.black,
            error: Colors.deepOrangeAccent,
            onError: Colors.white,
            errorContainer: Colors.deepOrange,
            onErrorContainer: Colors.black,
            tertiary: Colors.green,
            onTertiary: Colors.white,
            tertiaryContainer: Colors.amber.shade300,
            onTertiaryContainer: Colors.black,
          )
        : ColorScheme.dark(
            background: const Color(0xff212121),
            // background: const Color(0xff2F3136),
            onBackground: Colors.white,
            // secondary: const Color(0xffFFA031),
            secondary: const Color(0xffF9C92B),
            onSecondary: Colors.black,
            secondaryContainer: Colors.amber.shade300,
            onSecondaryContainer: Colors.black,
            primary: const Color(0xffF9C92B),
            onPrimary: Colors.black,
            surface: const Color(0xff18191C),
            onSurface: Colors.white,
            surfaceVariant: const Color(0xff18191C),
            onSurfaceVariant: Colors.white,
            error: Colors.pinkAccent,
            onError: Colors.black,
            errorContainer: Colors.pinkAccent,
            onErrorContainer: Colors.black,
            tertiary: Colors.green,
            onTertiary: Colors.black,
            tertiaryContainer: Colors.amber.shade300,
            onTertiaryContainer: Colors.black,
            outline: const Color(0xff2B2D31),
            outlineVariant: const Color(0xff4F545C),
          );

/// setup font
const _primaryFont = GoogleFonts.dmSans,
    _bigTitleFont = GoogleFonts.pathwayExtreme,
    _secondaryFont = GoogleFonts.dmSans;

TextTheme _textTheme([Color textColor = Colors.black]) => TextTheme(
      displayLarge: _bigTitleFont(
          color: textColor,
          fontSize: 105,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5),
      displayMedium: _bigTitleFont(
          color: textColor,
          fontSize: 65,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5),
      displaySmall: _bigTitleFont(
          color: textColor, fontSize: 52, fontWeight: FontWeight.w400),
      headlineMedium: _bigTitleFont(
          color: textColor,
          fontSize: 27,
          height: 1.2,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      headlineSmall: _bigTitleFont(
          color: textColor,
          fontSize: 24,
          letterSpacing: 0.08,
          fontWeight: FontWeight.w600),
      titleLarge: _primaryFont(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15),
      titleMedium: _primaryFont(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15),
      titleSmall: _primaryFont(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1),
      bodyLarge: _secondaryFont(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.2,
          letterSpacing: 0.1),
      bodyMedium: _secondaryFont(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25),
      labelLarge: _primaryFont(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25),
      bodySmall: _secondaryFont(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4),
      labelSmall: _secondaryFont(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5),
    );
